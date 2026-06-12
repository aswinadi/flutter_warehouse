import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Divider, Icons, Navigator, showDatePicker, showDialog, Theme;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../models/invoice_biaya.dart';
import '../providers/invoice_biaya_repository.dart';
import '../../../core/providers/company_provider.dart';
import '../../purchase_request/models/supplier.dart';
import '../../inventory/providers/asset_repository.dart';
import '../../../core/models/company.dart';

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

  List<XFile> _selectedFiles = [];
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
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Gagal Memuat'),
            content: Text('Gagal memuat data invoice: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
              ),
            ],
          ),
        );
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
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Sukses'),
            content: Text(widget.invoiceBiayaId == null ? 'Invoice Biaya berhasil dibuat.' : 'Invoice Biaya berhasil disimpan.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showError('Gagal menyimpan invoice: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Kesalahan'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
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
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text('Informasi Invoice', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText),
                              decoration: null,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Tanggal Invoice',
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 0,
                              onPressed: _selectInvoiceDate,
                              child: Text(
                                '${_invoiceDate.day.toString().padLeft(2, '0')}-${_invoiceDate.month.toString().padLeft(2, '0')}-${_invoiceDate.year}',
                                style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
                              ),
                            ),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Tanggal Jatuh Tempo',
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 0,
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Nilai & Mata Uang', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          _buildFormRow(
                            label: 'Mata Uang',
                            child: const Text('IDR', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Nilai Tagihan (IDR)',
                            child: CupertinoTextField(
                              controller: _amountController,
                              placeholder: '0.00',
                              placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: null,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const Divider(color: CupertinoColors.separator, height: 16),
                          _buildFormRow(
                            label: 'Pajak (IDR)',
                            child: CupertinoTextField(
                              controller: _taxAmountController,
                              placeholder: '0.00',
                              placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: null,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Informasi Tambahan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          _buildFormRow(
                            label: 'Catatan',
                            child: CupertinoTextField(
                              controller: _notesController,
                              placeholder: 'Tambahkan catatan jika ada...',
                              placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText),
                              maxLines: 3,
                              decoration: null,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Lampiran Dokumen', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CupertinoButton(
                            color: CupertinoColors.systemGrey5.resolveFrom(context),
                            padding: const EdgeInsets.all(12),
                            onPressed: _pickFiles,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.paperclip, color: CupertinoColors.label.resolveFrom(context), size: 18),
                                const SizedBox(width: 8),
                                Text('Pilih Foto/Dokumen', style: TextStyle(color: CupertinoColors.label.resolveFrom(context), fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          if (_selectedFiles.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            ..._selectedFiles.asMap().entries.map((entry) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(CupertinoIcons.doc, size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          entry.value.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        minSize: 0,
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
              minSize: 0,
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
