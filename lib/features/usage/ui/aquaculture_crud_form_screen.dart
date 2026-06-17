import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../providers/aquaculture_crud_config.dart';
import '../providers/aquaculture_crud_provider.dart';

class AquacultureCrudFormScreen extends ConsumerStatefulWidget {
  final String resource;
  final int? recordId;
  final bool isEmbedded;
  final VoidCallback? onSaved;
  final VoidCallback? onCancel;

  const AquacultureCrudFormScreen({
    super.key,
    required this.resource,
    this.recordId,
    this.isEmbedded = false,
    this.onSaved,
    this.onCancel,
  });

  @override
  ConsumerState<AquacultureCrudFormScreen> createState() => _AquacultureCrudFormScreenState();
}

class _AquacultureCrudFormScreenState extends ConsumerState<AquacultureCrudFormScreen> {
  final Map<String, dynamic> _formData = {};
  bool _isLoading = false;
  bool _isSaving = false;

  // Dropdown options
  List<dynamic> _companies = [];
  List<dynamic> _tambaks = [];
  List<dynamic> _bloks = [];
  List<dynamic> _moduls = [];
  List<dynamic> _ponds = [];
  List<dynamic> _cycles = [];

  // Controllers for text/number fields
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _loadOptions();
    if (widget.recordId != null) {
      _loadRecordData();
    } else {
      final config = aquacultureCrudConfigs[widget.resource];
      if (config != null) {
        for (var field in config.formFields) {
          if (field.type == FieldType.boolean) {
            _formData[field.name] = true;
          } else if (field.type == FieldType.date && field.required) {
            _formData[field.name] = DateFormat('yyyy-MM-dd').format(DateTime.now());
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  TextEditingController _getController(String fieldName, dynamic initialValue) {
    if (!_controllers.containsKey(fieldName)) {
      _controllers[fieldName] = TextEditingController(text: initialValue?.toString() ?? '');
    }
    return _controllers[fieldName]!;
  }

  Future<void> _loadOptions() async {
    setState(() => _isLoading = true);
    final repo = ref.read(aquacultureCrudRepositoryProvider);

    try {
      final config = aquacultureCrudConfigs[widget.resource];
      if (config == null) return;

      bool needCompanies = false;
      bool needTambaks = false;
      bool needBloks = false;
      bool needModuls = false;
      bool needPonds = false;
      bool needCycles = false;

      for (var field in config.formFields) {
        if (field.type == FieldType.selectCompany) needCompanies = true;
        if (field.type == FieldType.selectTambak) needTambaks = true;
        if (field.type == FieldType.selectBlok) needBloks = true;
        if (field.type == FieldType.selectModul) needModuls = true;
        if (field.type == FieldType.selectPond) needPonds = true;
        if (field.type == FieldType.selectCycle) needCycles = true;
      }

      final futures = <Future>[];
      if (needCompanies) {
        futures.add(repo.dio.get('wh/companies').then((res) {
          _companies = res.data['data'] as List;
          _companies.sort((a, b) => (a['company_name'] as String).compareTo(b['company_name'] as String));
        }));
      }
      if (needTambaks) {
        futures.add(repo.listAll('tambaks').then((res) {
          _tambaks = res;
          _tambaks.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
        }));
      }
      if (needBloks) {
        futures.add(repo.listAll('bloks').then((res) {
          _bloks = res;
          _bloks.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
        }));
      }
      if (needModuls) {
        futures.add(repo.listAll('moduls').then((res) {
          _moduls = res;
          _moduls.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
        }));
      }
      if (needPonds) {
        futures.add(repo.listAll('ponds').then((res) {
          _ponds = res;
          _ponds.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
        }));
      }
      if (needCycles) {
        futures.add(repo.listAll('cycles').then((res) {
          _cycles = res;
          _cycles.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
        }));
      }

      await Future.wait(futures);
    } catch (err) {
      debugPrint('Error loading select options: $err');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadRecordData() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(aquacultureCrudRepositoryProvider);
      final record = await repo.show(widget.resource, widget.recordId!);
      if (record != null && record is Map<String, dynamic>) {
        setState(() {
          _formData.addAll(record);
          _formData.forEach((key, value) {
            if (_controllers.containsKey(key)) {
              _controllers[key]!.text = value?.toString() ?? '';
            }
          });
        });
      }
    } catch (err) {
      debugPrint('Error loading record: $err');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showNotification(String message, {bool isError = false}) {
    if (!mounted) return;
    if (isError) {
      CupertinoGlassToast.showError(context, message);
    } else {
      CupertinoGlassToast.showSuccess(context, message);
    }
  }

  void _showCupertinoDatePicker(String fieldName) {
    final currentVal = _formData[fieldName];
    DateTime initialDate = DateTime.tryParse(currentVal ?? '') ?? DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        DateTime tempDate = initialDate;
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Container(
                color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Batal'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: const Text('Selesai'),
                      onPressed: () {
                        setState(() {
                          final formatted = DateFormat('yyyy-MM-dd').format(tempDate);
                          _formData[fieldName] = formatted;
                          _getController(fieldName, formatted).text = formatted;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: initialDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (date) {
                    tempDate = date;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsPicker<T>({
    required String title,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T> onSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(title),
        actions: items.map((item) {
          return CupertinoActionSheetAction(
            onPressed: () {
              onSelected(item);
              Navigator.pop(context);
            },
            child: Text(labelBuilder(item)),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    final config = aquacultureCrudConfigs[widget.resource];
    if (config == null) return;

    // Manual validation
    for (var field in config.formFields) {
      final val = _formData[field.name];
      if (field.required) {
        if (val == null || val.toString().trim().isEmpty) {
          _showNotification('${field.label} wajib diisi.', isError: true);
          return;
        }
      }
      if (field.type == FieldType.number && val != null && val.toString().trim().isNotEmpty) {
        if (double.tryParse(val.toString()) == null) {
          _showNotification('${field.label} harus berupa angka yang valid.', isError: true);
          return;
        }
      }
    }

    setState(() => _isSaving = true);
    final repo = ref.read(aquacultureCrudRepositoryProvider);

    try {
      final Map<String, dynamic> payload = {};
      for (var field in config.formFields) {
        dynamic val = _formData[field.name];
        if (field.type == FieldType.number && val != null) {
          val = double.tryParse(val.toString());
        }
        if (field.type == FieldType.boolean) {
          val = val == true;
        }
        payload[field.name] = val;
      }

      if (widget.recordId != null) {
        await repo.update(widget.resource, widget.recordId!, payload);
      } else {
        await repo.create(widget.resource, payload);
      }

      ref.read(aquacultureCrudListProvider(widget.resource).notifier).refresh();
      _showNotification('Data berhasil disimpan.');

      if (mounted) {
        if (widget.isEmbedded) {
          if (widget.onSaved != null) {
            widget.onSaved!();
          }
        } else {
          context.pop();
        }
      }
    } catch (err) {
      _showNotification('Gagal menyimpan: $err', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildSelectField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.subhead.copyWith(
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: CupertinoSpacing.xs),
        GestureDetector(
          onTap: onTap,
          child: CupertinoGlassContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: CupertinoSpacing.m,
              vertical: CupertinoSpacing.m,
            ),
            borderRadius: CupertinoSpacing.buttonRadius,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: context.subhead.copyWith(color: labelColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(CupertinoIcons.chevron_down, size: 14, color: secondaryLabel),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldInput(FieldConfig field) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final borderCol = CupertinoColors.separator.resolveFrom(context);

    switch (field.type) {
      case FieldType.text:
      case FieldType.number:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label + (field.required ? ' *' : ''),
              style: context.subhead.copyWith(fontWeight: FontWeight.w600, color: labelColor),
            ),
            const SizedBox(height: CupertinoSpacing.xs),
            CupertinoTextField(
              controller: _getController(field.name, _formData[field.name]),
              placeholder: field.placeholder,
              keyboardType: field.type == FieldType.number
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              padding: const EdgeInsets.symmetric(
                horizontal: CupertinoSpacing.m,
                vertical: CupertinoSpacing.m,
              ),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                border: Border.all(color: borderCol, width: 0.5),
                borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
              ),
              onChanged: (val) => _formData[field.name] = val,
            ),
          ],
        );

      case FieldType.boolean:
        final bool currentValue = _formData[field.name] == true;
        return CupertinoGlassContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: CupertinoSpacing.m,
            vertical: CupertinoSpacing.m,
          ),
          borderRadius: CupertinoSpacing.buttonRadius,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                field.label,
                style: context.subhead.copyWith(fontWeight: FontWeight.w600, color: labelColor),
              ),
              CupertinoSwitch(
                value: currentValue,
                onChanged: (val) => setState(() => _formData[field.name] = val),
              ),
            ],
          ),
        );

      case FieldType.date:
        final String currentDate = _formData[field.name]?.toString() ?? '';
        return _buildSelectField(
          label: field.label + (field.required ? ' *' : ''),
          value: currentDate.isNotEmpty ? currentDate : 'Pilih Tanggal',
          onTap: () => _showCupertinoDatePicker(field.name),
        );

      case FieldType.selectCompany:
        final currentVal = _formData[field.name];
        final selected = _companies.firstWhere((c) => c['id'] == currentVal, orElse: () => null);
        return _buildSelectField(
          label: field.label + (field.required ? ' *' : ''),
          value: selected != null ? (selected['company_name'] ?? '') : 'Pilih Perusahaan',
          onTap: () => _showOptionsPicker(
            title: 'Pilih Perusahaan',
            items: _companies,
            labelBuilder: (c) => c['company_name'] ?? '',
            onSelected: (val) {
              setState(() => _formData[field.name] = val['id']);
            },
          ),
        );

      case FieldType.selectTambak:
        final currentVal = _formData[field.name];
        final selected = _tambaks.firstWhere((t) => t['id'] == currentVal, orElse: () => null);
        return _buildSelectField(
          label: field.label + (field.required ? ' *' : ''),
          value: selected != null ? '${selected['name'] ?? ''} (${selected['company']?['company_name'] ?? ''})' : 'Pilih Tambak',
          onTap: () => _showOptionsPicker(
            title: 'Pilih Tambak',
            items: _tambaks,
            labelBuilder: (t) => '${t['name'] ?? ''} (${t['company']?['company_name'] ?? ''})',
            onSelected: (val) {
              setState(() => _formData[field.name] = val['id']);
            },
          ),
        );

      case FieldType.selectBlok:
        final currentVal = _formData[field.name];
        final selected = _bloks.firstWhere((b) => b['id'] == currentVal, orElse: () => null);
        return _buildSelectField(
          label: field.label + (field.required ? ' *' : ''),
          value: selected != null ? '${selected['name'] ?? ''} - ${selected['tambak']?['name'] ?? ''}' : 'Pilih Blok',
          onTap: () => _showOptionsPicker(
            title: 'Pilih Blok',
            items: _bloks,
            labelBuilder: (b) => '${b['name'] ?? ''} - ${b['tambak']?['name'] ?? ''}',
            onSelected: (val) {
              setState(() => _formData[field.name] = val['id']);
            },
          ),
        );

      case FieldType.selectModul:
        final currentVal = _formData[field.name];
        final selected = _moduls.firstWhere((m) => m['id'] == currentVal, orElse: () => null);
        return _buildSelectField(
          label: field.label + (field.required ? ' *' : ''),
          value: selected != null ? '${selected['name'] ?? ''} (Blok ${selected['blok']?['name'] ?? ''})' : 'Pilih Modul',
          onTap: () => _showOptionsPicker(
            title: 'Pilih Modul',
            items: _moduls,
            labelBuilder: (m) => '${m['name'] ?? ''} (Blok ${m['blok']?['name'] ?? ''} - ${m['blok']?['tambak']?['name'] ?? ''})',
            onSelected: (val) {
              setState(() => _formData[field.name] = val['id']);
            },
          ),
        );

      case FieldType.selectPond:
        final currentVal = _formData[field.name];
        final selected = _ponds.firstWhere((p) => p['id'] == currentVal, orElse: () => null);
        return _buildSelectField(
          label: field.label + (field.required ? ' *' : ''),
          value: selected != null ? '${selected['name'] ?? ''} (Modul ${selected['modul']?['name'] ?? ''})' : 'Pilih Petak',
          onTap: () => _showOptionsPicker(
            title: 'Pilih Petak',
            items: _ponds,
            labelBuilder: (p) => '${p['name'] ?? ''} (Modul ${p['modul']?['name'] ?? ''})',
            onSelected: (val) {
              setState(() => _formData[field.name] = val['id']);
            },
          ),
        );

      case FieldType.selectCycle:
        final currentVal = _formData[field.name];
        final selected = _cycles.firstWhere((cy) => cy['id'] == currentVal, orElse: () => null);
        return _buildSelectField(
          label: field.label + (field.required ? ' *' : ''),
          value: selected != null ? '${selected['name'] ?? ''} (${selected['company']?['company_name'] ?? ''})' : 'Pilih Siklus',
          onTap: () => _showOptionsPicker(
            title: 'Pilih Siklus',
            items: _cycles,
            labelBuilder: (cy) => '${cy['name'] ?? ''} (${cy['company']?['company_name'] ?? ''})',
            onSelected: (val) {
              setState(() => _formData[field.name] = val['id']);
            },
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = aquacultureCrudConfigs[widget.resource];
    final title = config?.title ?? 'Form';
    final actionText = widget.recordId != null ? 'Edit $title' : 'Tambah $title';
    final labelColor = CupertinoColors.label.resolveFrom(context);

    if (widget.isEmbedded) {
      return _isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          actionText,
                          style: context.title3.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                        ),
                      ),
                      if (widget.onCancel != null)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: widget.onCancel,
                          child: const Icon(CupertinoIcons.clear_circled, color: CupertinoColors.secondaryLabel),
                        ),
                    ],
                  ),
                  const SizedBox(height: CupertinoSpacing.l),
                  if (config != null)
                    ...config.formFields.map((field) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: CupertinoSpacing.l),
                        child: _buildFieldInput(field),
                      );
                    }),
                  const SizedBox(height: CupertinoSpacing.xl),
                  Row(
                    children: [
                      if (widget.onCancel != null) ...[
                        Expanded(
                          child: CupertinoButton(
                            onPressed: widget.onCancel,
                            color: const CupertinoDynamicColor.withBrightness(
                              color: Color(0xFFE5E5EA),
                              darkColor: Color(0xFF2C2C2E),
                            ).resolveFrom(context),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                            child: Text(
                              'BATAL',
                              style: TextStyle(color: labelColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: CupertinoSpacing.m),
                      ],
                      Expanded(
                        child: CupertinoButton.filled(
                          onPressed: _isSaving ? null : _saveForm,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                          child: _isSaving
                              ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                              : const Text('SIMPAN', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: Text(actionText),
        trailing: !_isLoading
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _isSaving ? null : _saveForm,
                child: _isSaving
                    ? const CupertinoActivityIndicator()
                    : const Text(
                        'Simpan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              )
            : null,
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                child: Column(
                  children: [
                    if (config != null)
                      ...config.formFields.map((field) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: CupertinoSpacing.l),
                          child: _buildFieldInput(field),
                        );
                      }),
                    const SizedBox(height: CupertinoSpacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed: _isSaving ? null : _saveForm,
                        borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                        child: _isSaving
                            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                            : const Text('SIMPAN'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
