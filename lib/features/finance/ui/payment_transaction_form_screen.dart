import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Scrollbar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../payment_request/models/payment_request.dart';
import '../../payment_request/providers/payment_request_repository.dart';
import '../models/company_bank_account.dart';

class PaymentTransactionFormScreen extends ConsumerStatefulWidget {
  const PaymentTransactionFormScreen({super.key});

  @override
  ConsumerState<PaymentTransactionFormScreen> createState() =>
      _PaymentTransactionFormScreenState();
}

class _PaymentTransactionFormScreenState extends ConsumerState<PaymentTransactionFormScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _transferRefController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _searchQuery = '';
  String? _selectedSupplier;
  final Set<PaymentRequestInvoice> _selectedInvoices = {};
  bool _isSubmitting = false;
  CompanyBankAccount? _selectedCompanyBankAccount;

  void _selectSupplier(String supplier, List<PaymentRequestInvoice> invoices) {
    setState(() {
      _selectedSupplier = supplier;
      _selectedInvoices.clear();
      _selectedInvoices.addAll(invoices);
      _selectedCompanyBankAccount = null;
      _bankNameController.clear();
      _bankAccountController.clear();
      _transferRefController.clear();
      _notesController.clear();
    });
  }

  void _showCompanyBankAccountPicker(List<CompanyBankAccount> accounts) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Pilih Rekening Bank Asal'),
        actions: accounts.map((account) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedCompanyBankAccount = account;
                _bankNameController.text = account.bankName;
                _bankAccountController.text = account.accountNumber;
              });
              Navigator.pop(context);
            },
            child: Text('${account.bankName} - ${account.accountNumber} (${account.accountName})'),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _transferRefController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final str = amount.toStringAsFixed(0);
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')}';
  }

  Widget _buildDueDateBadge(PaymentRequestInvoice invoice) {
    if (invoice.dueDate == null) {
      return Text(
        'Jatuh Tempo: -',
        style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
      );
    }

    final parsedDate = DateTime.tryParse(invoice.dueDate!);
    if (parsedDate == null) {
      return Text(
        'Jatuh Tempo: ${invoice.dueDate}',
        style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    
    final difference = targetDate.difference(today).inDays;
    final isOverdue = targetDate.isBefore(today);

    String text;
    Color color;
    Color textColor;

    if (isOverdue) {
      final days = today.difference(targetDate).inDays;
      text = 'JATUH TEMPO ($days hari lalu)';
      color = const Color(0xFFFF3B30).withValues(alpha: 0.15);
      textColor = const Color(0xFFFF3B30);
    } else if (difference <= 7) {
      text = 'AKAN JATUH TEMPO ($difference hari)';
      color = const Color(0xFFFF9500).withValues(alpha: 0.15);
      textColor = const Color(0xFFFF9500);
    } else {
      text = 'Jatuh Tempo: ${DateFormat('dd MMM yyyy').format(parsedDate)}';
      color = CupertinoColors.secondarySystemFill;
      textColor = CupertinoColors.secondaryLabel;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    String label;
    Color color;
    Color textColor;

    if (type == 'biaya') {
      label = 'Biaya';
      color = const Color(0xFFFF9500).withValues(alpha: 0.12);
      textColor = const Color(0xFFFF9500);
    } else if (type == 'additional_cost' || type == 'landed_cost') {
      label = 'Landed Cost';
      color = const Color(0xFF34C759).withValues(alpha: 0.12);
      textColor = const Color(0xFF34C759);
    } else {
      label = 'Supplier';
      color = const Color(0xFF007AFF).withValues(alpha: 0.12);
      textColor = const Color(0xFF007AFF);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: textColor, width: 0.5),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_selectedInvoices.isEmpty) return;

    // Show Confirmation Dialog
    final totalAmount = _selectedInvoices.fold<double>(0, (sum, item) => sum + (item.amount - item.paidAmount));
    
    showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Text(
          'Anda akan memproses pembayaran sebesar ${_formatCurrency(totalAmount)} '
          'untuk ${_selectedInvoices.length} invoice ke supplier $_selectedSupplier.\n\nApakah data sudah benar?',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ya, Bayar'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed != true) return;

      setState(() {
        _isSubmitting = true;
      });

      try {
        final repo = ref.read(paymentRequestRepositoryProvider);
        
        // Group selected invoices by paymentRequestId
        final groupedByPr = <int, List<PaymentRequestInvoice>>{};
        for (final inv in _selectedInvoices) {
          groupedByPr.putIfAbsent(inv.paymentRequestId, () => []).add(inv);
        }

        // Run payment requests calls in parallel
        await Future.wait(
          groupedByPr.entries.map((entry) {
            final prId = entry.key;
            final prInvoices = entry.value;

            final invoicesPayload = prInvoices.map((inv) => {
              'invoice_id': inv.id,
              'amount': inv.amount - inv.paidAmount,
            }).toList();

            return repo.payPaymentRequest(
              prId,
              invoices: invoicesPayload,
              bankName: _bankNameController.text.trim().isEmpty ? null : _bankNameController.text.trim(),
              bankAccount: _bankAccountController.text.trim().isEmpty ? null : _bankAccountController.text.trim(),
              transferReference: _transferRefController.text.trim().isEmpty ? null : _transferRefController.text.trim(),
              notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            );
          }),
        );

        // Success Dialog
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Pembayaran Berhasil'),
              content: const Text('Transaksi pembayaran berhasil disimpan dan status tagihan telah diperbarui.'),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    context.pop(true); // return true to list screen to refresh
                  },
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Pembayaran Gagal'),
              content: Text('Terjadi kesalahan saat memproses pembayaran: $e'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Tutup'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final company = ref.watch(selectedCompanyProvider);
    final approvedPrsAsync = ref.watch(paymentRequestsProvider(status: 'approved'));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final isWide = MediaQuery.of(context).size.width > 900;

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: const Text('Catat Pembayaran Baru'),
        previousPageTitle: 'Kembali',
      ),
      child: SafeArea(
        child: company == null
            ? const Center(child: Text('Pilih perusahaan terlebih dahulu'))
            : approvedPrsAsync.when(
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, stack) => Center(child: Text('Gagal memuat data: $err')),
                data: (paymentRequests) {
                  // Extract all unpaid invoices from approved payment requests
                  final allUnpaidInvoices = <PaymentRequestInvoice>[];
                  for (final pr in paymentRequests) {
                    for (final inv in pr.invoices) {
                      if (inv.paymentStatus.toLowerCase() != 'paid') {
                        allUnpaidInvoices.add(inv);
                      }
                    }
                  }

                  // Group by supplier name
                  final groupedSuppliers = <String, List<PaymentRequestInvoice>>{};
                  for (final inv in allUnpaidInvoices) {
                    final name = inv.supplierName ?? 'TANPA NAMA SUPPLIER';
                    groupedSuppliers.putIfAbsent(name, () => []).add(inv);
                  }

                  if (isWide) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 380,
                          child: _buildSupplierList(groupedSuppliers, labelColor),
                        ),
                        Container(
                          width: 1,
                          color: CupertinoColors.separator.resolveFrom(context),
                        ),
                        Expanded(
                          child: _selectedSupplier != null
                              ? _buildInvoiceChecklist(
                                  groupedSuppliers[_selectedSupplier!] ?? [],
                                  labelColor,
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.square_list_fill,
                                        size: 48,
                                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                      ),
                                      const SizedBox(height: CupertinoSpacing.l),
                                      Text(
                                        'Pilih supplier di panel kiri untuk memproses pembayaran',
                                        style: context.callout.copyWith(
                                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    );
                  } else {
                    if (_selectedSupplier == null) {
                      return _buildSupplierList(groupedSuppliers, labelColor);
                    } else {
                      final supplierInvoices = groupedSuppliers[_selectedSupplier!] ?? [];
                      return _buildInvoiceChecklist(supplierInvoices, labelColor);
                    }
                  }
                },
              ),
      ),
    );
  }

  Widget _buildSupplierList(Map<String, List<PaymentRequestInvoice>> grouped, Color labelColor) {
    final searchLower = _searchQuery.toLowerCase();
    
    // Filtered list of suppliers
    final sortedSuppliers = grouped.keys
        .where((supplier) => supplier.toLowerCase().contains(searchLower))
        .toList()
      ..sort();

    if (sortedSuppliers.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Cari nama supplier...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Tidak ada pengajuan pembayaran disetujui\nyang menunggu pembayaran.',
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.secondaryLabel),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          child: CupertinoSearchTextField(
            controller: _searchController,
            placeholder: 'Cari nama supplier...',
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin),
              itemCount: sortedSuppliers.length,
              itemBuilder: (context, index) {
                final supplier = sortedSuppliers[index];
                final invoices = grouped[supplier] ?? [];
                
                // Calculate totals
                final totalAmount = invoices.fold<double>(0.0, (sum, inv) => sum + (inv.amount - inv.paidAmount));

                return GestureDetector(
                  onTap: () {
                    _selectSupplier(supplier, invoices);
                  },
                  child: CupertinoGlassContainer(
                    margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                    padding: const EdgeInsets.all(CupertinoSpacing.m),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                supplier,
                                style: context.body.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${invoices.length} Tagihan Menunggu Pembayaran',
                                style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatCurrency(totalAmount),
                              style: context.body.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6E56CF),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Icon(
                              CupertinoIcons.chevron_forward,
                              size: 16,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceChecklist(List<PaymentRequestInvoice> invoices, Color labelColor) {
    final secondaryBgColor = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final isWide = MediaQuery.of(context).size.width > 900;
    final company = ref.watch(selectedCompanyProvider);
    final companyBankAccountsAsync = ref.watch(companyBankAccountsProvider(companyId: company?.id ?? 0));
    final supplierAsync = ref.watch(supplierByNameProvider(
      supplierName: _selectedSupplier!,
      companyId: company?.id ?? 0,
    ));
    
    // Sort invoices by due date
    invoices.sort((a, b) {
      final aDate = a.dueDate ?? a.invoiceDate;
      final bDate = b.dueDate ?? b.invoiceDate;
      return aDate.compareTo(bDate);
    });

    final totalSelectedAmount = _selectedInvoices.fold<double>(
      0.0,
      (sum, inv) => sum + (inv.amount - inv.paidAmount),
    );

    return Column(
      children: [
        // Supplier Header Block
        Container(
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Penerima Pembayaran:',
                      style: context.caption2.copyWith(color: secondaryLabelColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedSupplier!,
                      style: context.title3.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                    ),
                  ],
                ),
              ),
              if (!isWide)
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m),
                  color: CupertinoColors.systemFill,
                  minSize: 32,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () {
                    setState(() {
                      _selectedSupplier = null;
                      _selectedInvoices.clear();
                    });
                  },
                  child: Text(
                    'Ubah',
                    style: context.footnote.copyWith(
                      fontWeight: FontWeight.bold,
                      color: labelColor,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Scrollable checklist & Form fields
        Expanded(
          child: Scrollbar(
            child: ListView(
              padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
              children: [
                // Vendor Bank Details Card (fetched from Master Supplier)
                supplierAsync.when(
                  data: (supplier) {
                    final hasBankInfo = supplier != null &&
                        supplier.bankName != null &&
                        supplier.bankName!.trim().isNotEmpty &&
                        supplier.bankAccount != null &&
                        supplier.bankAccount!.trim().isNotEmpty;

                    if (!hasBankInfo) {
                      return CupertinoGlassContainer(
                        margin: const EdgeInsets.only(bottom: CupertinoSpacing.l),
                        padding: const EdgeInsets.all(CupertinoSpacing.m),
                        backgroundColor: CupertinoColors.systemOrange.resolveFrom(context).withValues(alpha: 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.warning_fill,
                                  size: 16,
                                  color: CupertinoColors.systemOrange.resolveFrom(context),
                                ),
                                const SizedBox(width: CupertinoSpacing.s),
                                Text(
                                  'Rekening Bank Vendor/Supplier',
                                  style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: CupertinoSpacing.s),
                            Text(
                              'Informasi rekening bank belum diisi di Master Supplier untuk supplier ini.',
                              style: context.body.copyWith(color: labelColor, fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return CupertinoGlassContainer(
                      margin: const EdgeInsets.only(bottom: CupertinoSpacing.l),
                      padding: const EdgeInsets.all(CupertinoSpacing.m),
                      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(CupertinoIcons.info_circle_fill, size: 16, color: CupertinoColors.activeBlue.resolveFrom(context)),
                              const SizedBox(width: CupertinoSpacing.s),
                              Text(
                                'Rekening Bank Vendor/Supplier',
                                style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: CupertinoSpacing.s),
                          Text(
                            'Bank: ${supplier.bankName}',
                            style: context.body.copyWith(color: labelColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'No. Rekening: ${supplier.bankAccount}',
                            style: context.body.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Nama Penerima: ${supplier.bankAccountName ?? "-"}',
                            style: context.body.copyWith(color: labelColor),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: CupertinoSpacing.l),
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                  error: (err, stack) => const SizedBox.shrink(),
                ),

                Text(
                  'Pilih Invoice Yang Akan Dibayar',
                  style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                ),
                const SizedBox(height: CupertinoSpacing.s),

                // Invoices checklist
                ...invoices.map((item) {
                  final isSelected = _selectedInvoices.contains(item);
                  final outstanding = item.amount - item.paidAmount;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedInvoices.remove(item);
                        } else {
                          _selectedInvoices.add(item);
                        }
                      });
                    },
                    child: CupertinoGlassContainer(
                      margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                      padding: const EdgeInsets.all(CupertinoSpacing.m),
                      borderColor: isSelected ? const Color(0xFF6E56CF) : null,
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.circle,
                            color: isSelected ? const Color(0xFF6E56CF) : CupertinoColors.secondaryLabel,
                            size: 22,
                          ),
                          const SizedBox(width: CupertinoSpacing.m),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.invoiceNumber,
                                      style: context.body.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                                    ),
                                    _buildTypeBadge(item.type),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tanggal Invoice: ${item.invoiceDate}',
                                  style: context.caption2.copyWith(color: secondaryLabelColor),
                                ),
                                const SizedBox(height: 6),
                                _buildDueDateBadge(item),
                              ],
                            ),
                          ),
                          const SizedBox(width: CupertinoSpacing.m),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatCurrency(outstanding),
                                style: context.body.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                              ),
                              if (item.paidAmount > 0)
                                Text(
                                  'Dibayar: ${_formatCurrency(item.paidAmount)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough,
                                    color: secondaryLabelColor,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: CupertinoSpacing.l),
                const Divider(),
                const SizedBox(height: CupertinoSpacing.l),

                // Payment Details Form Header
                Text(
                  'Detail Transaksi Transfer Bank',
                  style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                ),
                const SizedBox(height: CupertinoSpacing.m),

                // Company Bank Account Selector Dropdown Row
                Text('Pilih Rekening Bank Asal', style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor)),
                const SizedBox(height: CupertinoSpacing.s),
                companyBankAccountsAsync.when(
                  loading: () => const CupertinoActivityIndicator(),
                  error: (err, stack) => Text('Gagal memuat rekening bank: $err', style: const TextStyle(color: CupertinoColors.systemRed)),
                  data: (accounts) {
                    if (accounts.isEmpty) {
                      return Text(
                        'Tidak ada rekening bank terdaftar untuk perusahaan ini.',
                        style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      );
                    }
                    
                    return GestureDetector(
                      onTap: () => _showCompanyBankAccountPicker(accounts),
                      child: Container(
                        padding: const EdgeInsets.all(CupertinoSpacing.m),
                        decoration: BoxDecoration(
                          color: secondaryBgColor,
                          border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                          borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedCompanyBankAccount != null
                                    ? '${_selectedCompanyBankAccount!.bankName} - ${_selectedCompanyBankAccount!.accountNumber} (${_selectedCompanyBankAccount!.accountName})'
                                    : 'Pilih Rekening Bank Perusahaan...',
                                style: TextStyle(
                                  color: _selectedCompanyBankAccount != null
                                      ? labelColor
                                      : CupertinoColors.placeholderText.resolveFrom(context),
                                ),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_down,
                              size: 16,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: CupertinoSpacing.m),

                // Bank Name Input
                Text('Nama Bank Asal', style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor)),
                const SizedBox(height: CupertinoSpacing.s),
                CupertinoTextField(
                  controller: _bankNameController,
                  placeholder: 'Contoh: BCA, MANDIRI, BRI',
                  padding: const EdgeInsets.all(CupertinoSpacing.m),
                  decoration: BoxDecoration(
                    color: secondaryBgColor,
                    border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
                  ),
                  style: TextStyle(color: labelColor),
                ),
                const SizedBox(height: CupertinoSpacing.m),

                // Bank Account Input
                Text('Nomor Rekening Pengirim', style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor)),
                const SizedBox(height: CupertinoSpacing.s),
                CupertinoTextField(
                  controller: _bankAccountController,
                  placeholder: 'Contoh: 8290312345',
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.all(CupertinoSpacing.m),
                  decoration: BoxDecoration(
                    color: secondaryBgColor,
                    border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
                  ),
                  style: TextStyle(color: labelColor),
                ),
                const SizedBox(height: CupertinoSpacing.m),

                // Transfer Reference Input
                Text('Nomor Referensi Transfer / Ref', style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor)),
                const SizedBox(height: CupertinoSpacing.s),
                CupertinoTextField(
                  controller: _transferRefController,
                  placeholder: 'Contoh: TRF-39048123',
                  padding: const EdgeInsets.all(CupertinoSpacing.m),
                  decoration: BoxDecoration(
                    color: secondaryBgColor,
                    border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
                  ),
                  style: TextStyle(color: labelColor),
                ),
                const SizedBox(height: CupertinoSpacing.m),

                // Notes Input
                Text('Catatan / Keterangan', style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor)),
                const SizedBox(height: CupertinoSpacing.s),
                CupertinoTextField(
                  controller: _notesController,
                  placeholder: 'Catatan tambahan transaksi (opsional)',
                  maxLines: 3,
                  padding: const EdgeInsets.all(CupertinoSpacing.m),
                  decoration: BoxDecoration(
                    color: secondaryBgColor,
                    border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
                  ),
                  style: TextStyle(color: labelColor),
                ),
                const SizedBox(height: CupertinoSpacing.xxxl), // spacer for bottom panel
              ],
            ),
          ),
        ),

        // Sticky Bottom Panel
        CupertinoGlassContainer(
          borderRadius: 0,
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selectedInvoices.length} Invoice Terpilih',
                      style: context.caption1.copyWith(color: secondaryLabelColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatCurrency(totalSelectedAmount),
                      style: context.title3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6E56CF),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 180,
                  height: CupertinoSpacing.primaryButtonHeight,
                  child: CupertinoButton(
                    color: const Color(0xFF6E56CF),
                    disabledColor: CupertinoColors.inactiveGray.withValues(alpha: 0.5),
                    padding: EdgeInsets.zero,
                    onPressed: _selectedInvoices.isEmpty || _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                        : const Text(
                            'Kirim Pembayaran',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
