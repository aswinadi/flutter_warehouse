import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/invoice_biaya_repository.dart';
import '../providers/chart_of_account_repository.dart';
import '../providers/cost_centre_repository.dart';
import '../models/invoice_biaya_detail.dart';
import '../models/chart_of_account.dart';
import '../models/cost_centre.dart';
import '../models/cost_code.dart';

import '../../../core/providers/company_provider.dart';
import '../../purchase_request/models/supplier.dart';
import '../../inventory/providers/asset_repository.dart';
import '../../inventory/models/asset.dart' show AssetEmployee;
import '../../../core/models/company.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../../../core/widgets/cupertino_glass_bottom_sheet.dart';
import '../../../core/utils/currency_utils.dart';

class InvoiceBiayaFormScreen extends ConsumerStatefulWidget {
  final int? invoiceBiayaId; // If provided, we are in Edit mode

  const InvoiceBiayaFormScreen({
    super.key,
    this.invoiceBiayaId,
  });

  @override
  ConsumerState<InvoiceBiayaFormScreen> createState() => _InvoiceBiayaFormScreenState();
}

class _InvoiceBiayaFormScreenState extends ConsumerState<InvoiceBiayaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  Company? _selectedCompany;
  Supplier? _selectedSupplier;
  
  final _vendorInvoiceNumberController = TextEditingController();
  final _notesController = TextEditingController();
  final _taxInvoiceNumberController = TextEditingController();

  DateTime _invoiceDate = DateTime.now();
  DateTime? _dueDate;
  DateTime? _taxInvoiceDate;

  String? _selectedCostCenterCode;
  final String _selectedJvType = 'Reguler'; // Static choice

  List<InvoiceBiayaDetail> _details = [
    const InvoiceBiayaDetail(coaCode: '', debit: 0.0, credit: 0.0)
  ];

  List<UniqueKey> _detailKeys = [
    UniqueKey()
  ];

  final List<XFile> _selectedFiles = [];
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void dispose() {
    _vendorInvoiceNumberController.dispose();
    _notesController.dispose();
    _taxInvoiceNumberController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      if (widget.invoiceBiayaId != null) {
        _loadInvoiceData();
      } else {
        _prefillCompany();
      }
      _isInit = true;
    }
  }

  Future<void> _prefillCompany() async {
    try {
      final companies = await ref.read(companiesProvider.future);
      if (companies.isNotEmpty && mounted) {
        setState(() {
          _selectedCompany = companies.first;
        });
        _setDefaultCostCenter();
      }
    } catch (_) {}
  }

  Future<void> _setDefaultCostCenter() async {
    if (_selectedCompany == null) return;
    try {
      final ccs = await ref.read(costCentresProvider(companyId: _selectedCompany!.id).future);
      final defaultCc = ccs.firstWhere(
        (c) => c.name.toLowerCase().contains('lokasi 1'),
        orElse: () => ccs.first,
      );
      if (mounted) {
        setState(() {
          _selectedCostCenterCode = defaultCc.code;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadInvoiceData() async {
    setState(() => _isLoading = true);
    try {
      final detail = await ref.read(invoiceBiayaRepositoryProvider).getInvoiceBiayaDetail(widget.invoiceBiayaId!);
      
      // Load companies
      final companies = await ref.read(companiesProvider.future);
      _selectedCompany = companies.firstWhere((c) => c.id == detail.companyId, orElse: () => companies.first);

      // Load suppliers
      final suppliers = await ref.read(assetSuppliersProvider(companyId: null).future);
      _selectedSupplier = suppliers.firstWhere((s) => s.id == detail.supplierId, orElse: () => suppliers.first);

      _vendorInvoiceNumberController.text = detail.vendorInvoiceNumber ?? '';
      _notesController.text = detail.notes ?? '';
      _taxInvoiceNumberController.text = detail.taxInvoiceNumber ?? '';
      
      _invoiceDate = DateTime.tryParse(detail.invoiceDate) ?? DateTime.now();
      _dueDate = detail.dueDate != null ? DateTime.tryParse(detail.dueDate!) : null;
      _taxInvoiceDate = detail.taxInvoiceDate != null ? DateTime.tryParse(detail.taxInvoiceDate!) : null;

      _selectedCostCenterCode = detail.costCenterCode;
      
      if (detail.details.isNotEmpty) {
        _details = List.from(detail.details);
        _detailKeys = List.generate(detail.details.length, (_) => UniqueKey());
      } else {
        _details = [const InvoiceBiayaDetail(coaCode: '', debit: 0.0, credit: 0.0)];
        _detailKeys = [UniqueKey()];
      }

    } catch (e) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal memuat data invoice: $e');
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  double get _totalDebit {
    return _details.fold(0.0, (sum, item) => sum + item.debit);
  }

  double get _totalCredit {
    return _details.fold(0.0, (sum, item) => sum + item.credit);
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate, ValueChanged<DateTime> onChanged) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
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
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate,
                onDateTimeChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(images);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _addDetailRow() {
    setState(() {
      _details.add(InvoiceBiayaDetail(
        coaCode: '',
        debit: 0.0,
        credit: 0.0,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      ));
      _detailKeys.add(UniqueKey());
    });
  }

  void _removeDetailRow(int index) {
    if (_details.length <= 1) {
      CupertinoGlassToast.showError(context, 'Harus ada minimal 1 baris jurnal.');
      return;
    }
    setState(() {
      _details.removeAt(index);
      _detailKeys.removeAt(index);
    });
  }

  Future<void> _saveInvoice() async {
    if (_selectedCompany == null) {
      _showError('Silakan pilih Perusahaan');
      return;
    }
    if (_selectedSupplier == null) {
      _showError('Silakan pilih Pemasok');
      return;
    }
    if (_vendorInvoiceNumberController.text.isEmpty) {
      _showError('No. Nota Supplier tidak boleh kosong');
      return;
    }

    // Detail Validation
    for (int i = 0; i < _details.length; i++) {
      final d = _details[i];
      if (d.coaCode.isEmpty) {
        _showError('Baris ke-${i + 1}: Silakan pilih Kode Akun (COA).');
        return;
      }
      if (d.debit <= 0 && d.credit <= 0) {
        _showError('Baris ke-${i + 1}: Nominal Debet atau Kredit harus diisi.');
        return;
      }
    }

    // Balance check
    final totalDebit = _totalDebit;
    final totalCredit = _totalCredit;
    final diff = (totalDebit - totalCredit).abs();
    if (diff > 0.01) {
      _showError('Total Debet dan Kredit tidak seimbang (Selisih: IDR ${formatCurrency(diff, 'IDR')}).');
      return;
    }
    if (totalDebit <= 0) {
      _showError('Nominal jurnal tidak boleh nol.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(invoiceBiayaRepositoryProvider);
      
      if (widget.invoiceBiayaId == null) {
        // Create new
        await repository.createInvoiceBiaya(
          companyId: _selectedCompany!.id,
          supplierId: _selectedSupplier!.id,
          vendorInvoiceNumber: _vendorInvoiceNumberController.text,
          invoiceDate: _invoiceDate.toIso8601String().substring(0, 10),
          dueDate: _dueDate?.toIso8601String().substring(0, 10),
          amount: totalDebit,
          taxAmount: 0.0,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          taxInvoiceNumber: _taxInvoiceNumberController.text.isNotEmpty ? _taxInvoiceNumberController.text : null,
          taxInvoiceDate: _taxInvoiceDate?.toIso8601String().substring(0, 10),
          costCenterCode: _selectedCostCenterCode,
          jvType: _selectedJvType,
          details: _details,
          files: _selectedFiles,
        );
      } else {
        // Update existing
        await repository.updateInvoiceBiaya(
          widget.invoiceBiayaId!,
          vendorInvoiceNumber: _vendorInvoiceNumberController.text,
          invoiceDate: _invoiceDate.toIso8601String().substring(0, 10),
          dueDate: _dueDate?.toIso8601String().substring(0, 10),
          amount: totalDebit,
          taxAmount: 0.0,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          taxInvoiceNumber: _taxInvoiceNumberController.text.isNotEmpty ? _taxInvoiceNumberController.text : null,
          taxInvoiceDate: _taxInvoiceDate?.toIso8601String().substring(0, 10),
          costCenterCode: _selectedCostCenterCode,
          jvType: _selectedJvType,
          details: _details,
          files: _selectedFiles,
        );
      }

      ref.invalidate(invoiceBiayasProvider);
      if (widget.invoiceBiayaId != null) {
        ref.invalidate(invoiceBiayaDetailProvider(widget.invoiceBiayaId!));
      }

      if (mounted) {
        CupertinoGlassToast.showSuccess(
          context, 
          widget.invoiceBiayaId == null ? 'Invoice Biaya berhasil dibuat.' : 'Invoice Biaya berhasil disimpan.'
        );
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) context.pop();
        });
      }
    } catch (e) {
      _showError('Gagal menyimpan invoice: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      CupertinoGlassToast.showError(context, message);
    }
  }

  void _showSearchPicker<T>({
    required String title,
    required List<T> items,
    required String Function(T) itemLabelBuilder,
    required String Function(T) itemSublabelBuilder,
    required bool Function(T, String) filterFn,
    required ValueChanged<T> onSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SearchPickerBottomSheet<T>(
          title: title,
          items: items,
          itemLabelBuilder: itemLabelBuilder,
          itemSublabelBuilder: itemSublabelBuilder,
          filterFn: filterFn,
          onSelected: onSelected,
        );
      },
    );
  }

  void _showPreviewSplit(String parentCode, double amount) {
    if (amount <= 0) {
      _showError('Silakan masukkan nominal debet/kredit terlebih dahulu.');
      return;
    }
    CupertinoGlassBottomSheet.show(
      context,
      title: 'Pratinjau Distribusi Cost Center',
      child: ProrationPreviewWidget(
        parentCode: parentCode,
        amount: amount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companiesAsync = ref.watch(companiesProvider);
    final suppliersAsync = ref.watch(assetSuppliersProvider(companyId: null));
    
    final companyId = _selectedCompany?.id ?? 0;
    final coasAsync = ref.watch(chartOfAccountsProvider(companyId: companyId));
    final costCentresAsync = ref.watch(costCentresProvider(companyId: companyId));
    final costCodesAsync = ref.watch(costCodesProvider(companyId: companyId));
    final employeesAsync = ref.watch(assetEmployeesProvider(companyId: companyId));

    final balanceDiff = (_totalDebit - _totalCredit).abs();
    final isBalanced = balanceDiff < 0.01 && (_totalDebit > 0 || _totalCredit > 0);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          widget.invoiceBiayaId == null ? 'Buat Invoice Biaya' : 'Edit Invoice Jurnal Biaya',
          style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoading ? null : _saveInvoice,
          child: Text(
            'Simpan',
            style: TextStyle(
              color: CupertinoColors.activeBlue.resolveFrom(context), 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                  children: [
                    // Section A: Informasi Invoice & Supplier
                    _buildSectionHeader('Informasi Invoice & Supplier'),
                    CupertinoGlassContainer(
                      borderRadius: CupertinoSpacing.cardRadius,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildPickerRow<Company>(
                            label: 'Perusahaan',
                            value: _selectedCompany,
                            placeholder: 'Pilih Perusahaan...',
                            asyncValue: companiesAsync,
                            onSelected: widget.invoiceBiayaId != null
                                ? null
                                : (c) {
                                    setState(() {
                                      _selectedCompany = c;
                                      _selectedSupplier = null;
                                      _selectedCostCenterCode = null;
                                      _details = [const InvoiceBiayaDetail(coaCode: '', debit: 0.0, credit: 0.0)];
                                      _detailKeys = [UniqueKey()];
                                    });
                                    _setDefaultCostCenter();
                                  },
                            itemLabelBuilder: (c) => c.companyName,
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildPickerRow<Supplier>(
                            label: 'Nama Supplier',
                            value: _selectedSupplier,
                            placeholder: _selectedCompany == null ? 'Pilih Perusahaan dulu' : 'Pilih Supplier...',
                            asyncValue: suppliersAsync,
                            onSelected: widget.invoiceBiayaId != null
                                ? null
                                : (s) {
                                    setState(() {
                                      _selectedSupplier = s;
                                    });
                                  },
                            itemLabelBuilder: (s) => s.name,
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'No. Nota Supplier',
                            child: CupertinoTextField(
                              controller: _vendorInvoiceNumberController,
                              placeholder: 'Contoh: INV/123/ABC',
                              placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText.resolveFrom(context)),
                              decoration: null,
                              padding: EdgeInsets.zero,
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Tanggal Invoice',
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                onPressed: () => _selectDate(context, _invoiceDate, (d) {
                                  setState(() => _invoiceDate = d);
                                }),
                                child: Text(
                                  '${_invoiceDate.day.toString().padLeft(2, '0')}-${_invoiceDate.month.toString().padLeft(2, '0')}-${_invoiceDate.year}',
                                  style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Tanggal Jatuh Tempo',
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                onPressed: () => _selectDate(context, _dueDate ?? DateTime.now(), (d) {
                                  setState(() => _dueDate = d);
                                }),
                                child: Text(
                                  _dueDate == null
                                      ? 'Pilih Tanggal...'
                                      : '${_dueDate!.day.toString().padLeft(2, '0')}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.year}',
                                  style: TextStyle(
                                    color: _dueDate == null ? CupertinoColors.placeholderText : CupertinoColors.label.resolveFrom(context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Paid Amount (Total Kredit)',
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'IDR ${formatCurrency(_totalCredit, 'IDR')}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.xl),

                    // Section B: Perpajakan & Klasifikasi
                    _buildSectionHeader('Perpajakan & Klasifikasi'),
                    CupertinoGlassContainer(
                      borderRadius: CupertinoSpacing.cardRadius,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildFormRow(
                            label: 'No. Faktur Pajak',
                            child: CupertinoTextField(
                              controller: _taxInvoiceNumberController,
                              placeholder: 'Contoh: 010.000-26.XXXXXXXX',
                              placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText.resolveFrom(context)),
                              decoration: null,
                              padding: EdgeInsets.zero,
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Tanggal Faktur Pajak',
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                onPressed: () => _selectDate(context, _taxInvoiceDate ?? DateTime.now(), (d) {
                                  setState(() => _taxInvoiceDate = d);
                                }),
                                child: Text(
                                  _taxInvoiceDate == null
                                      ? 'Pilih Tanggal...'
                                      : '${_taxInvoiceDate!.day.toString().padLeft(2, '0')}-${_taxInvoiceDate!.month.toString().padLeft(2, '0')}-${_taxInvoiceDate!.year}',
                                  style: TextStyle(
                                    color: _taxInvoiceDate == null ? CupertinoColors.placeholderText : CupertinoColors.label.resolveFrom(context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildCostCenterHeaderRow(costCentresAsync),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Tipe Invoice Biaya',
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Reguler',
                                style: TextStyle(color: CupertinoColors.inactiveGray),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.xl),

                    // Section C: Keterangan Utama
                    _buildSectionHeader('Keterangan Utama'),
                    CupertinoGlassContainer(
                      borderRadius: CupertinoSpacing.cardRadius,
                      padding: const EdgeInsets.all(16.0),
                      child: CupertinoTextField(
                        controller: _notesController,
                        placeholder: 'Keterangan utama transaksi...',
                        placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText.resolveFrom(context)),
                        maxLines: 3,
                        decoration: null,
                        padding: EdgeInsets.zero,
                        onChanged: (val) {
                          // Update missing notes in details to match
                          setState(() {
                            for (int i = 0; i < _details.length; i++) {
                              if (_details[i].notes == null || _details[i].notes!.isEmpty) {
                                // Just visual tracking, actual submit will use fallback notes
                              }
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.xl),

                    // Repeater Section: Journal Entries
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('Journal Entries'),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _addDetailRow,
                          child: const Row(
                            children: [
                              Icon(CupertinoIcons.add_circled_solid),
                              SizedBox(width: 4),
                              Text('Tambah Baris'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CupertinoSpacing.s),

                    // Table-Type Input Grid for Desktop/Tablet View
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: CupertinoGlassContainer(
                        width: 1180,
                        borderRadius: CupertinoSpacing.cardRadius,
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildGridHeader(context),
                            Column(
                              children: _details.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final detail = entry.value;
                                return InvoiceBiayaDetailRow(
                                  key: _detailKeys[idx],
                                  idx: idx,
                                  detail: detail,
                                  coas: coasAsync.value ?? [],
                                  costCentres: costCentresAsync.value ?? [],
                                  costCodes: costCodesAsync.value ?? [],
                                  employees: employeesAsync.value ?? [],
                                  onChanged: (updated) {
                                    setState(() {
                                      _details[idx] = updated;
                                    });
                                  },
                                  onDeleted: () => _removeDetailRow(idx),
                                  onPreviewSplit: _showPreviewSplit,
                                  fallbackNotes: _notesController.text,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: CupertinoSpacing.xl),

                    // Summary & Balanced Status
                    _buildSummaryCard(balanceDiff, isBalanced),
                    const SizedBox(height: CupertinoSpacing.xl),

                    // Attachments Section
                    _buildSectionHeader('Lampiran Dokumen'),
                    CupertinoGlassContainer(
                      borderRadius: CupertinoSpacing.cardRadius,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CupertinoButton(
                            color: CupertinoColors.systemGrey5.resolveFrom(context),
                            padding: const EdgeInsets.all(12.0),
                            onPressed: _pickFiles,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.paperclip, color: CupertinoColors.label.resolveFrom(context), size: 18),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Pilih Foto/Dokumen', 
                                  style: TextStyle(
                                    color: CupertinoColors.label.resolveFrom(context), 
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ],
                            ),
                          ),
                          if (_selectedFiles.isNotEmpty) ...[
                            const SizedBox(height: 12.0),
                            ..._selectedFiles.asMap().entries.map((fEntry) => Container(
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(CupertinoIcons.doc, size: 16),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          fEntry.value.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.footnote,
                                        ),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        child: const Icon(CupertinoIcons.minus_circle_fill, color: CupertinoColors.systemRed, size: 18),
                                        onPressed: () => _removeFile(fEntry.key),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
        ),
      ),
    );
  }

  Widget _buildFormRow({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: context.subhead.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildCostCenterHeaderRow(AsyncValue<List<CostCentre>> asyncValue) {
    return _buildFormRow(
      label: 'Cost Center Header',
      child: Align(
        alignment: Alignment.centerRight,
        child: asyncValue.when(
          data: (items) {
            final selectedCc = items.firstWhere((cc) => cc.code == _selectedCostCenterCode, orElse: () => items.first);
            return CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () {
                _showSearchPicker<CostCentre>(
                  title: 'Cost Center Header',
                  items: items,
                  itemLabelBuilder: (c) => c.name,
                  itemSublabelBuilder: (c) => c.code,
                  filterFn: (c, q) => c.name.toLowerCase().contains(q.toLowerCase()) || c.code.toLowerCase().contains(q.toLowerCase()),
                  onSelected: (cc) {
                    setState(() {
                      _selectedCostCenterCode = cc.code;
                    });
                  },
                );
              },
              child: Text(
                _selectedCostCenterCode != null ? selectedCc.name : 'Pilih Cost Center...',
                style: TextStyle(
                  color: _selectedCostCenterCode != null ? CupertinoColors.label.resolveFrom(context) : CupertinoColors.placeholderText,
                  fontWeight: _selectedCostCenterCode != null ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            );
          },
          loading: () => const CupertinoActivityIndicator(),
          error: (err, _) => Text('Error: $err', style: const TextStyle(color: CupertinoColors.systemRed)),
        ),
      ),
    );
  }

  Widget _buildPickerRow<T>({
    required String label,
    required T? value,
    required String placeholder,
    required AsyncValue<List<T>> asyncValue,
    required void Function(T)? onSelected,
    required String Function(T) itemLabelBuilder,
  }) {
    return _buildFormRow(
      label: label,
      child: Align(
        alignment: Alignment.centerRight,
        child: asyncValue.when(
          data: (items) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: onSelected == null
                  ? null
                  : () {
                      if (items.isEmpty) return;
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: Text('Pilih $label'),
                          actions: items.map((item) {
                            return CupertinoActionSheetAction(
                              child: Text(itemLabelBuilder(item)),
                              onPressed: () {
                                onSelected(item);
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('Batal'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
              child: Text(
                value != null ? itemLabelBuilder(value) : placeholder,
                style: TextStyle(
                  color: onSelected == null
                      ? CupertinoColors.inactiveGray
                      : (value != null ? CupertinoColors.label.resolveFrom(context) : CupertinoColors.placeholderText),
                  fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            );
          },
          loading: () => const CupertinoActivityIndicator(),
          error: (err, _) => Text('Error: $err', style: const TextStyle(color: CupertinoColors.systemRed)),
        ),
      ),
    );
  }





  Widget _buildSummaryCard(double diff, bool isBalanced) {
    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Ringkasan Entri Jurnal',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Debet:'),
              Text(
                'IDR ${formatCurrency(_totalDebit, 'IDR')}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Kredit:'),
              Text(
                'IDR ${formatCurrency(_totalCredit, 'IDR')}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(color: CupertinoColors.separator, height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Status Keseimbangan:'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isBalanced
                      ? CupertinoColors.activeGreen.withOpacity(0.15)
                      : CupertinoColors.destructiveRed.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  isBalanced ? 'Balanced' : 'Unbalanced',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: isBalanced ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
                  ),
                ),
              ),
            ],
          ),
          if (diff > 0.01) ...[
            const SizedBox(height: 6),
            Text(
              '* Selisih: IDR ${formatCurrency(diff, 'IDR')}',
              textAlign: TextAlign.right,
              style: const TextStyle(color: CupertinoColors.destructiveRed, fontSize: 12.0),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGridHeader(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? CupertinoColors.systemGrey6.darkColor : CupertinoColors.systemGrey6;

    return Container(
      decoration: BoxDecoration(
        color: headerBg.withOpacity(0.4),
        border: const Border(
          bottom: BorderSide(color: CupertinoColors.separator, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: const Row(
        children: [
          SizedBox(width: 200, child: Text('Kode Akun (COA)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0))),
          SizedBox(width: 160, child: Text('Kode Proyek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0))),
          SizedBox(width: 140, child: Text('Cost Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0))),
          SizedBox(width: 130, child: Text('Nominal Debet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0))),
          SizedBox(width: 130, child: Text('Nominal Kredit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0))),
          SizedBox(width: 150, child: Text('Karyawan/Staff', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0))),
          SizedBox(width: 200, child: Text('Keterangan Baris', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0))),
          SizedBox(width: 50, child: Text('', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0))),
        ],
      ),
    );
  }
}

class SearchPickerBottomSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final String Function(T) itemSublabelBuilder;
  final bool Function(T, String) filterFn;
  final ValueChanged<T> onSelected;

  const SearchPickerBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemLabelBuilder,
    required this.itemSublabelBuilder,
    required this.filterFn,
    required this.onSelected,
  });

  @override
  State<SearchPickerBottomSheet<T>> createState() => _SearchPickerBottomSheetState<T>();
}

class _SearchPickerBottomSheetState<T> extends State<SearchPickerBottomSheet<T>> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? const Color(0xEE1C1C1E) : const Color(0xEEFFFFFF);

    final filteredItems = widget.items.where((item) {
      if (_searchQuery.isEmpty) return true;
      return widget.filterFn(item, _searchQuery);
    }).toList();

    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 16.0,
              top: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            decoration: BoxDecoration(
              color: defaultBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              border: Border.all(
                color: isDark ? const Color(0x22FFFFFF) : const Color(0x1F000000),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0x44FFFFFF) : const Color(0x22000000),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Tutup'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                CupertinoSearchTextField(
                  controller: _searchController,
                  placeholder: 'Cari...',
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                const SizedBox(height: 12.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        alignment: Alignment.centerLeft,
                        onPressed: () {
                          widget.onSelected(item);
                          Navigator.pop(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemLabelBuilder(item),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: CupertinoColors.label.resolveFrom(context),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            if (widget.itemSublabelBuilder(item).isNotEmpty) ...[
                              const SizedBox(height: 2.0),
                              Text(
                                widget.itemSublabelBuilder(item),
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8.0),
                            const Divider(height: 1, color: CupertinoColors.separator),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProrationPreviewWidget extends ConsumerWidget {
  final String parentCode;
  final double amount;

  const ProrationPreviewWidget({
    super.key,
    required this.parentCode,
    required this.amount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(proratedPreviewProvider(parentCode: parentCode, qty: amount));

    return previewAsync.when(
      data: (list) {
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tidak ada child cost center yang aktif pada siklus saat ini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, decoration: TextDecoration.none),
            ),
          );
        }

        // Show table
        return Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context).withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Petak / Blok', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, decoration: TextDecoration.none)
                      )
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Luas (m2)', 
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, decoration: TextDecoration.none)
                      )
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Porsi (%)', 
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, decoration: TextDecoration.none)
                      )
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Nilai (IDR)', 
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, decoration: TextDecoration.none)
                      )
                    ),
                  ],
                ),
              ),
              const Divider(color: CupertinoColors.separator),
              ...list.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value as Map<String, dynamic>;
                final code = item['code'] as String;
                final name = item['name'] as String;
                final luasM2 = (item['luas_m2'] as num?)?.toDouble() ?? 0.0;
                final sharePercent = (item['share_percent'] as num?)?.toDouble();
                final qty = (item['qty'] as num).toDouble();
                final isLast = (idx == list.length - 1);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          '$name\n$code',
                          style: const TextStyle(fontSize: 12, color: CupertinoColors.label, decoration: TextDecoration.none),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          luasM2.toStringAsFixed(0),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 12, decoration: TextDecoration.none),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          sharePercent != null ? '${sharePercent.toStringAsFixed(2)}%' : '-',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 12, decoration: TextDecoration.none),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatCurrency(qty, 'IDR'),
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                            ),
                            if (isLast)
                              const Text(
                                '* Termasuk pembulatan',
                                style: TextStyle(fontSize: 9, fontStyle: FontStyle.italic, color: CupertinoColors.secondaryLabel, decoration: TextDecoration.none),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CupertinoActivityIndicator(),
        ),
      ),
      error: (err, _) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Gagal memuat pratinjau: $err',
          style: const TextStyle(color: CupertinoColors.destructiveRed, decoration: TextDecoration.none),
        ),
      ),
    );
  }
}

class InvoiceBiayaDetailRow extends StatefulWidget {
  final int idx;
  final InvoiceBiayaDetail detail;
  final List<ChartOfAccount> coas;
  final List<CostCentre> costCentres;
  final List<CostCode> costCodes;
  final List<AssetEmployee> employees;
  final ValueChanged<InvoiceBiayaDetail> onChanged;
  final VoidCallback onDeleted;
  final void Function(String, double) onPreviewSplit;
  final String fallbackNotes;

  const InvoiceBiayaDetailRow({
    super.key,
    required this.idx,
    required this.detail,
    required this.coas,
    required this.costCentres,
    required this.costCodes,
    required this.employees,
    required this.onChanged,
    required this.onDeleted,
    required this.onPreviewSplit,
    required this.fallbackNotes,
  });

  @override
  State<InvoiceBiayaDetailRow> createState() => _InvoiceBiayaDetailRowState();
}

class _InvoiceBiayaDetailRowState extends State<InvoiceBiayaDetailRow> {
  late TextEditingController _debitController;
  late TextEditingController _creditController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _debitController = TextEditingController(
      text: widget.detail.debit > 0 ? formatCurrency(widget.detail.debit, '') : '',
    );
    _creditController = TextEditingController(
      text: widget.detail.credit > 0 ? formatCurrency(widget.detail.credit, '') : '',
    );
    _notesController = TextEditingController(
      text: widget.detail.notes ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant InvoiceBiayaDetailRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final currentDebit = _parseIndonesianDouble(_debitController.text);
    if (currentDebit != widget.detail.debit) {
      _debitController.text = widget.detail.debit > 0 ? formatCurrency(widget.detail.debit, '') : '';
    }

    final currentCredit = _parseIndonesianDouble(_creditController.text);
    if (currentCredit != widget.detail.credit) {
      _creditController.text = widget.detail.credit > 0 ? formatCurrency(widget.detail.credit, '') : '';
    }

    if (_notesController.text != (widget.detail.notes ?? '')) {
      _notesController.text = widget.detail.notes ?? '';
    }
  }

  @override
  void dispose() {
    _debitController.dispose();
    _creditController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateDetail(InvoiceBiayaDetail updated) {
    widget.onChanged(updated);
  }

  double _parseIndonesianDouble(String text) {
    final cleanText = text.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleanText) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedCoa = widget.coas.firstWhere(
      (c) => c.coaCode == widget.detail.coaCode,
      orElse: () => const ChartOfAccount(id: 0, companyId: 0, coaCode: '', coaName: '', isActive: false),
    );

    final selectedCc = widget.costCentres.firstWhere(
      (c) => c.code == widget.detail.projectCode,
      orElse: () => const CostCentre(id: 0, code: '', name: '', luasM2: 0, isActive: false),
    );
    final isParentCostCenter = selectedCc.isParent;

    final selectedCostCode = widget.costCodes.firstWhere(
      (c) => c.code == widget.detail.costCode,
      orElse: () => const CostCode(id: 0, companyId: 0, code: '', name: '', isActive: false),
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          // 1. Kode Akun (COA)
          SizedBox(
            width: 200,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              alignment: Alignment.centerLeft,
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return SearchPickerBottomSheet<ChartOfAccount>(
                      title: 'Pilih Akun (COA)',
                      items: widget.coas,
                      itemLabelBuilder: (c) => c.coaCode,
                      itemSublabelBuilder: (c) => c.coaName,
                      filterFn: (c, q) => c.coaCode.toLowerCase().contains(q.toLowerCase()) || c.coaName.toLowerCase().contains(q.toLowerCase()),
                      onSelected: (c) {
                        _updateDetail(widget.detail.copyWith(coaCode: c.coaCode, coaName: c.coaName));
                      },
                    );
                  },
                );
              },
              child: Text(
                widget.detail.coaCode.isNotEmpty 
                    ? '${widget.detail.coaCode}\n${selectedCoa.coaName}' 
                    : 'Pilih Akun...',
                style: TextStyle(
                  fontSize: 13.0,
                  color: widget.detail.coaCode.isNotEmpty 
                      ? CupertinoColors.label.resolveFrom(context) 
                      : CupertinoColors.placeholderText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // 2. Kode Proyek
          SizedBox(
            width: 160,
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return SearchPickerBottomSheet<CostCentre>(
                            title: 'Pilih Kode Proyek',
                            items: widget.costCentres,
                            itemLabelBuilder: (c) => c.name,
                            itemSublabelBuilder: (c) => c.code,
                            filterFn: (c, q) => c.name.toLowerCase().contains(q.toLowerCase()) || c.code.toLowerCase().contains(q.toLowerCase()),
                            onSelected: (cc) {
                              _updateDetail(widget.detail.copyWith(projectCode: cc.code));
                            },
                          );
                        },
                      );
                    },
                    child: Text(
                      widget.detail.projectCode != null && widget.detail.projectCode!.isNotEmpty 
                          ? selectedCc.name 
                          : 'Pilih Proyek...',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: widget.detail.projectCode != null && widget.detail.projectCode!.isNotEmpty
                            ? CupertinoColors.label.resolveFrom(context) 
                            : CupertinoColors.placeholderText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (isParentCostCenter) ...[
                  GestureDetector(
                    onTap: () {
                      final amount = widget.detail.debit > 0 ? widget.detail.debit : widget.detail.credit;
                      widget.onPreviewSplit(widget.detail.projectCode!, amount);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        CupertinoIcons.info_circle_fill,
                        size: 14.0,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 3. Cost Code
          SizedBox(
            width: 140,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              alignment: Alignment.centerLeft,
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return SearchPickerBottomSheet<CostCode>(
                      title: 'Pilih Cost Code',
                      items: widget.costCodes,
                      itemLabelBuilder: (c) => c.name,
                      itemSublabelBuilder: (c) => c.code,
                      filterFn: (c, q) => c.name.toLowerCase().contains(q.toLowerCase()) || c.code.toLowerCase().contains(q.toLowerCase()),
                      onSelected: (cc) {
                        _updateDetail(widget.detail.copyWith(costCode: cc.code));
                      },
                    );
                  },
                );
              },
              child: Text(
                widget.detail.costCode != null && widget.detail.costCode!.isNotEmpty 
                    ? selectedCostCode.name 
                    : 'Pilih Cost...',
                style: TextStyle(
                  fontSize: 13.0,
                  color: widget.detail.costCode != null && widget.detail.costCode!.isNotEmpty
                      ? CupertinoColors.label.resolveFrom(context) 
                      : CupertinoColors.placeholderText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // 4. Nominal Debet
          SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CupertinoTextField(
                controller: _debitController,
                placeholder: '0,00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  IndonesianNumberFormatter(),
                ],
                enabled: widget.detail.credit <= 0.0,
                decoration: BoxDecoration(
                  color: widget.detail.credit > 0.0 
                      ? CupertinoColors.quaternarySystemFill.resolveFrom(context)
                      : CupertinoColors.systemFill.resolveFrom(context),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                style: TextStyle(
                  fontSize: 13.0,
                  color: widget.detail.credit > 0.0 
                      ? CupertinoColors.secondaryLabel.resolveFrom(context)
                      : CupertinoColors.label.resolveFrom(context),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                onChanged: (val) {
                  final parsed = _parseIndonesianDouble(val);
                  _updateDetail(widget.detail.copyWith(
                    debit: parsed,
                    credit: parsed > 0.0 ? 0.0 : widget.detail.credit,
                  ));
                },
              ),
            ),
          ),

          // 5. Nominal Kredit
          SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CupertinoTextField(
                controller: _creditController,
                placeholder: '0,00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  IndonesianNumberFormatter(),
                ],
                enabled: widget.detail.debit <= 0.0,
                decoration: BoxDecoration(
                  color: widget.detail.debit > 0.0 
                      ? CupertinoColors.quaternarySystemFill.resolveFrom(context)
                      : CupertinoColors.systemFill.resolveFrom(context),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                style: TextStyle(
                  fontSize: 13.0,
                  color: widget.detail.debit > 0.0 
                      ? CupertinoColors.secondaryLabel.resolveFrom(context)
                      : CupertinoColors.label.resolveFrom(context),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                onChanged: (val) {
                  final parsed = _parseIndonesianDouble(val);
                  _updateDetail(widget.detail.copyWith(
                    credit: parsed,
                    debit: parsed > 0.0 ? 0.0 : widget.detail.debit,
                  ));
                },
              ),
            ),
          ),

          // 6. Karyawan/Staff
          SizedBox(
            width: 150,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              alignment: Alignment.centerLeft,
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return SearchPickerBottomSheet<AssetEmployee>(
                      title: 'Pilih Staff Karyawan',
                      items: widget.employees,
                      itemLabelBuilder: (e) => e.fullName,
                      itemSublabelBuilder: (e) => 'ID: ${e.id}',
                      filterFn: (e, q) => e.fullName.toLowerCase().contains(q.toLowerCase()),
                      onSelected: (e) {
                        _updateDetail(widget.detail.copyWith(staffName: e.fullName));
                      },
                    );
                  },
                );
              },
              child: Text(
                widget.detail.staffName ?? 'Pilih Staff...',
                style: TextStyle(
                  fontSize: 13.0,
                  color: widget.detail.staffName != null
                      ? CupertinoColors.label.resolveFrom(context) 
                      : CupertinoColors.placeholderText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // 7. Keterangan Baris
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CupertinoTextField(
                controller: _notesController,
                placeholder: widget.fallbackNotes.isNotEmpty ? widget.fallbackNotes : 'Keterangan...',
                placeholderStyle: const TextStyle(fontStyle: FontStyle.italic, color: CupertinoColors.placeholderText, fontSize: 13.0),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemFill.resolveFrom(context),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                style: const TextStyle(fontSize: 13.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                onChanged: (val) {
                  _updateDetail(widget.detail.copyWith(notes: val));
                },
              ),
            ),
          ),

          // 8. Delete Action
          SizedBox(
            width: 50,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: widget.onDeleted,
              child: const Icon(CupertinoIcons.delete, color: CupertinoColors.systemRed, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class IndonesianNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final regExp = RegExp(r'^[0-9.,]*$');
    if (!regExp.hasMatch(newValue.text)) {
      return oldValue;
    }

    final commaCount = ','.allMatches(newValue.text).length;
    if (commaCount > 1) {
      return oldValue;
    }

    final parts = newValue.text.split(',');
    final wholePartRaw = parts[0].replaceAll('.', '');
    
    final wholePartFormatted = _formatThousandSeparator(wholePartRaw);

    String newText = wholePartFormatted;
    if (parts.length > 1) {
      newText += ',' + parts[1];
    } else if (newValue.text.endsWith(',')) {
      newText += ',';
    }

    int selectionIndex = newValue.selection.end;
    int contentCharsBeforeCursor = 0;
    for (int i = 0; i < selectionIndex; i++) {
      if (i < newValue.text.length && newValue.text[i] != '.') {
        contentCharsBeforeCursor++;
      }
    }

    int newSelectionIndex = 0;
    int contentCharsSeen = 0;
    while (contentCharsSeen < contentCharsBeforeCursor && newSelectionIndex < newText.length) {
      if (newText[newSelectionIndex] != '.') {
        contentCharsSeen++;
      }
      newSelectionIndex++;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }

  String _formatThousandSeparator(String raw) {
    if (raw.isEmpty) return '';
    final buffer = StringBuffer();
    int len = raw.length;
    for (int i = 0; i < len; i++) {
      buffer.write(raw[i]);
      if ((len - 1 - i) % 3 == 0 && i != len - 1) {
        buffer.write('.');
      }
    }
    return buffer.toString();
  }
}
