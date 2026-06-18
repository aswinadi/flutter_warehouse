import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/invoice_biaya_repository.dart';
import '../../../core/providers/company_provider.dart';
import '../../purchase_request/models/supplier.dart';
import '../../inventory/providers/asset_repository.dart';
import '../../../core/models/company.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

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
  final _amountController = TextEditingController();
  final _taxAmountController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _invoiceDate = DateTime.now();
  DateTime? _dueDate;

  final List<XFile> _selectedFiles = [];
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void dispose() {
    _vendorInvoiceNumberController.dispose();
    _amountController.dispose();
    _taxAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      if (widget.invoiceBiayaId != null) {
        _loadInvoiceData();
      }
      _isInit = true;
    }
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
      _amountController.text = detail.amount.toString();
      _taxAmountController.text = detail.taxAmount.toString();
      _notesController.text = detail.notes ?? '';
      
      _invoiceDate = DateTime.tryParse(detail.invoiceDate) ?? DateTime.now();
      _dueDate = detail.dueDate != null ? DateTime.tryParse(detail.dueDate!) : null;

    } catch (e) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal memuat data invoice: $e');
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectInvoiceDate() async {
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
                initialDateTime: _invoiceDate,
                onDateTimeChanged: (val) {
                  setState(() {
                    _invoiceDate = val;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
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
                    child: const Text('Hapus'),
                    onPressed: () {
                      setState(() {
                        _dueDate = null;
                      });
                      Navigator.pop(context);
                    },
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
                initialDateTime: _dueDate ?? DateTime.now(),
                onDateTimeChanged: (val) {
                  setState(() {
                    _dueDate = val;
                  });
                },
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
      _showError('No. Invoice Vendor tidak boleh kosong');
      return;
    }
    
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount < 0) {
      _showError('Nilai tagihan tidak valid');
      return;
    }

    final double taxAmount = double.tryParse(_taxAmountController.text) ?? 0;

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
          amount: amount,
          taxAmount: taxAmount,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          files: _selectedFiles,
        );
      } else {
        // Update existing
        await repository.updateInvoiceBiaya(
          widget.invoiceBiayaId!,
          vendorInvoiceNumber: _vendorInvoiceNumberController.text,
          invoiceDate: _invoiceDate.toIso8601String().substring(0, 10),
          dueDate: _dueDate?.toIso8601String().substring(0, 10),
          amount: amount,
          taxAmount: taxAmount,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          files: _selectedFiles,
        );
      }

      ref.invalidate(invoiceBiayasProvider);
      if (widget.invoiceBiayaId != null) {
        ref.invalidate(invoiceBiayaDetailProvider(widget.invoiceBiayaId!));
      }

      if (mounted) {
        CupertinoGlassToast.showSuccess(context, widget.invoiceBiayaId == null ? 'Invoice Biaya berhasil dibuat.' : 'Invoice Biaya berhasil disimpan.');
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

  @override
  Widget build(BuildContext context) {
    final companiesAsync = ref.watch(companiesProvider);
    final suppliersAsync = ref.watch(assetSuppliersProvider(companyId: null));

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          widget.invoiceBiayaId == null ? 'Buat Invoice Biaya' : 'Edit Invoice Biaya',
          style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoading ? null : _saveInvoice,
          child: Text(
            'Simpan',
            style: TextStyle(color: CupertinoColors.activeBlue.resolveFrom(context), fontWeight: FontWeight.bold),
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
                    Text('Informasi Invoice', style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                    const SizedBox(height: CupertinoSpacing.s),
                    CupertinoGlassContainer(
                      borderRadius: CupertinoSpacing.cardRadius,
                      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
                      child: Column(
                        children: [
                          _buildPickerRow<Company>(
                            label: 'Perusahaan',
                            value: _selectedCompany,
                            placeholder: 'Pilih Perusahaan...',
                            asyncValue: companiesAsync,
                            onSelected: widget.invoiceBiayaId != null
                                ? null // Disable changing company in edit mode
                                : (company) {
                                    setState(() {
                                      _selectedCompany = company;
                                      _selectedSupplier = null; // reset supplier when company changes
                                    });
                                  },
                            itemLabelBuilder: (c) => c.companyName,
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildPickerRow<Supplier>(
                            label: 'Pemasok',
                            value: _selectedSupplier,
                            placeholder: _selectedCompany == null ? 'Pilih Perusahaan dulu' : 'Pilih Pemasok...',
                            asyncValue: suppliersAsync,
                            onSelected: widget.invoiceBiayaId != null
                                ? null // Disable changing supplier in edit mode
                                : (supplier) {
                                    setState(() {
                                      _selectedSupplier = supplier;
                                    });
                                  },
                            itemLabelBuilder: (s) => s.name,
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'No. Invoice Vendor',
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
                                onPressed: _selectInvoiceDate,
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
                                onPressed: _selectDueDate,
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
                        ],
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.xl),
                    Text('Nilai & Mata Uang', style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                    const SizedBox(height: CupertinoSpacing.s),
                    CupertinoGlassContainer(
                      borderRadius: CupertinoSpacing.cardRadius,
                      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
                      child: Column(
                        children: [
                          _buildFormRow(
                            label: 'Mata Uang',
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Text('IDR', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Nilai Tagihan (IDR)',
                            child: CupertinoTextField(
                              controller: _amountController,
                              placeholder: '0.00',
                              placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText.resolveFrom(context)),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: null,
                              padding: EdgeInsets.zero,
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Pajak (IDR)',
                            child: CupertinoTextField(
                              controller: _taxAmountController,
                              placeholder: '0.00',
                              placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText.resolveFrom(context)),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: null,
                              padding: EdgeInsets.zero,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.xl),
                    Text('Informasi Tambahan', style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                    const SizedBox(height: CupertinoSpacing.s),
                    CupertinoGlassContainer(
                      borderRadius: CupertinoSpacing.cardRadius,
                      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
                      child: Column(
                        children: [
                          _buildFormRow(
                            label: 'Catatan',
                            child: CupertinoTextField(
                              controller: _notesController,
                              placeholder: 'Tambahkan catatan jika ada...',
                              placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText.resolveFrom(context)),
                              maxLines: 3,
                              decoration: null,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.xl),
                    Text('Lampiran Dokumen', style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                    const SizedBox(height: CupertinoSpacing.s),
                    CupertinoGlassContainer(
                      borderRadius: CupertinoSpacing.cardRadius,
                      padding: const EdgeInsets.all(CupertinoSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CupertinoButton(
                            color: CupertinoColors.systemGrey5.resolveFrom(context),
                            padding: const EdgeInsets.all(CupertinoSpacing.m),
                            onPressed: _pickFiles,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.paperclip, color: CupertinoColors.label.resolveFrom(context), size: 18),
                                const SizedBox(width: CupertinoSpacing.s),
                                Text('Pilih Foto/Dokumen', style: TextStyle(color: CupertinoColors.label.resolveFrom(context), fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          if (_selectedFiles.isNotEmpty) ...[
                            const SizedBox(height: CupertinoSpacing.m),
                            ..._selectedFiles.asMap().entries.map((entry) => Container(
                                  margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                                  padding: const EdgeInsets.all(CupertinoSpacing.s),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(CupertinoIcons.doc, size: 16),
                                      const SizedBox(width: CupertinoSpacing.s),
                                      Expanded(
                                        child: Text(
                                          entry.value.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.footnote,
                                        ),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        child: const Icon(CupertinoIcons.minus_circle_fill, color: CupertinoColors.systemRed, size: 18),
                                        onPressed: () => _removeFile(entry.key),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildFormRow({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xs + 2),
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
}
