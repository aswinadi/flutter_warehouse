import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Scrollbar, VerticalDivider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../providers/payment_request_repository.dart';
import '../models/payment_request.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';

class PaymentRequestFormScreen extends ConsumerStatefulWidget {
  const PaymentRequestFormScreen({super.key});

  @override
  ConsumerState<PaymentRequestFormScreen> createState() => _PaymentRequestFormScreenState();
}

class _PaymentRequestFormScreenState extends ConsumerState<PaymentRequestFormScreen> {
  final Set<AvailableInvoice> _selectedInvoices = <AvailableInvoice>{};
  String _searchQuery = '';
  String _selectedTypeFilter = 'all'; // all, supplier, biaya, landed_cost
  DateTime _requestDate = DateTime.now();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  AvailableInvoice? _activePreviewInvoice;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  double get _totalAmount {
    return _selectedInvoices.fold(0.0, (sum, item) => sum + item.amount);
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Batal'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text('Selesai'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _requestDate,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() => _requestDate = newDateTime);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _previewInvoiceDetails(BuildContext context, AvailableInvoice item) {
    final isWide = MediaQuery.of(context).size.width > 900;
    if (isWide) {
      setState(() {
        _activePreviewInvoice = item;
      });
    } else {
      // Mobile - open Bottom Sheet
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(CupertinoSpacing.dialogRadius)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  // Modal header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.l, vertical: CupertinoSpacing.m),
                    decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(CupertinoSpacing.dialogRadius)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rincian Tagihan',
                          style: context.headline.copyWith(fontWeight: FontWeight.bold),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0.5, thickness: 0.5, color: CupertinoColors.separator),
                  Expanded(
                    child: InvoiceDetailPreview(
                      id: item.id,
                      type: item.type,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _submit() async {
    if (_selectedInvoices.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(paymentRequestRepositoryProvider);
      final formattedDate = DateFormat('yyyy-MM-dd').format(_requestDate);
      final payload = _selectedInvoices.map((inv) => {
        'id': inv.id,
        'type': inv.type,
      }).toList();

      await repository.createPaymentRequest(
        invoices: payload,
        requestDate: formattedDate,
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
      );

      // Invalidate payment requests list to trigger refresh
      ref.invalidate(paymentRequestsProvider());

      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Permintaan pembayaran berhasil dibuat.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  context.pop(); // close dialog
                  context.pop(); // close form screen
                },
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Gagal'),
            content: Text('Gagal membuat permintaan pembayaran: ${_getErrorMessage(e)}'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => context.pop(),
              )
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _getErrorMessage(dynamic e) {
    if (e is DioException) {
      final responseData = e.response?.data;
      if (responseData is Map) {
        if (responseData['errors'] != null && responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map;
          if (errors.isNotEmpty) {
            final firstErrorVal = errors.values.first;
            if (firstErrorVal is List && firstErrorVal.isNotEmpty) {
              return firstErrorVal.first.toString();
            }
            return firstErrorVal.toString();
          }
        }
        if (responseData['message'] != null) {
          return responseData['message'].toString();
        }
        if (responseData['error'] != null) {
          return responseData['error'].toString();
        }
      }
      return e.message ?? e.toString();
    }
    return e.toString();
  }

  Widget _buildTypeBadge(String type) {
    String label;
    Color color;
    Color textColor = CupertinoColors.white;

    switch (type) {
      case 'supplier':
        label = 'Supplier';
        color = const Color(0xFF007AFF);
        break;
      case 'biaya':
        label = 'Biaya';
        color = const Color(0xFFFF9500);
        break;
      case 'landed_cost':
        label = 'Landed Cost';
        color = const Color(0xFF34C759);
        break;
      default:
        label = type;
        color = CupertinoColors.inactiveGray;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: context.caption2.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildDueDateBadge(AvailableInvoice item) {
    final parsedDate = DateTime.tryParse(item.dueDate ?? item.invoiceDate);
    if (parsedDate == null) return const SizedBox.shrink();

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
        style: context.caption2.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final isWide = MediaQuery.of(context).size.width > 900;

    if (selectedCompany == null) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Buat Permintaan Pembayaran'),
          backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        ),
        child: const Center(
          child: Text('Perusahaan belum dipilih.'),
        ),
      );
    }

    final invoicesAsync = ref.watch(availableInvoicesProvider(companyId: selectedCompany.id));

    // Define the main checklist and input column
    final mainListColumn = Column(
      children: [
        // Company info header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(CupertinoSpacing.l),
          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Perusahaan',
                style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel),
              ),
              const SizedBox(height: CupertinoSpacing.xs),
              Text(
                selectedCompany.companyName,
                style: context.headline.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Divider(height: 0.5, thickness: 0.5, color: CupertinoColors.separator),

        // Search and Filters
        Container(
          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
          padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.l, vertical: CupertinoSpacing.s),
          child: Column(
            children: [
              CupertinoSearchTextField(
                placeholder: 'Cari nomor invoice atau supplier...',
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
              const SizedBox(height: CupertinoSpacing.s),
              SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<String>(
                  groupValue: _selectedTypeFilter,
                  onValueChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedTypeFilter = val);
                    }
                  },
                  children: const {
                    'all': Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text('Semua')),
                    'supplier': Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text('Faktur')),
                    'biaya': Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text('Biaya')),
                    'landed_cost': Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text('Tambahan')),
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 0.5, thickness: 0.5, color: CupertinoColors.separator),

        // List of Invoices
        Expanded(
          child: invoicesAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Gagal mengambil tagihan: $err', style: context.subhead),
                  const SizedBox(height: CupertinoSpacing.s),
                  CupertinoButton(
                    child: const Text('Coba Lagi'),
                    onPressed: () => ref.invalidate(availableInvoicesProvider(companyId: selectedCompany.id)),
                  )
                ],
              ),
            ),
            data: (invoices) {
              // Apply search and filter
              final filtered = invoices.where((inv) {
                final matchesSearch = inv.invoiceNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    inv.supplierName.toLowerCase().contains(_searchQuery.toLowerCase());
                final matchesType = _selectedTypeFilter == 'all' || inv.type == _selectedTypeFilter;
                return matchesSearch && matchesType;
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada tagihan tersedia',
                    style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel),
                  ),
                );
              }

              return Scrollbar(
                child: ListView.separated(
                  padding: const EdgeInsets.all(CupertinoSpacing.l),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: CupertinoSpacing.s),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final isSelected = _selectedInvoices.contains(item);
                    final isPreviewed = _activePreviewInvoice == item;

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
                      child: Container(
                        padding: const EdgeInsets.all(CupertinoSpacing.m),
                        decoration: BoxDecoration(
                          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                          borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
                          border: Border.all(
                            color: isPreviewed
                                ? CupertinoColors.activeBlue
                                : isSelected
                                    ? CupertinoColors.activeBlue.withValues(alpha: 0.5)
                                    : CupertinoColors.separator.resolveFrom(context),
                            width: isPreviewed ? 2.0 : (isSelected ? 1.5 : 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? CupertinoIcons.check_mark_circled_solid
                                  : CupertinoIcons.circle,
                              color: isSelected
                                  ? CupertinoColors.activeBlue
                                  : CupertinoColors.placeholderText.resolveFrom(context),
                              size: 24,
                            ),
                            const SizedBox(width: CupertinoSpacing.m),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.invoiceNumber,
                                          style: context.headline.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: CupertinoSpacing.s),
                                      _buildTypeBadge(item.type),
                                    ],
                                  ),
                                  const SizedBox(height: CupertinoSpacing.xs),
                                  Text(
                                    item.supplierName,
                                    style: context.subhead.copyWith(
                                      color: CupertinoColors.secondaryLabel,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: CupertinoSpacing.s),
                                  _buildDueDateBadge(item),
                                ],
                              ),
                            ),
                            const SizedBox(width: CupertinoSpacing.m),
                            GestureDetector(
                              onTap: () => _previewInvoiceDetails(context, item),
                              child: Container(
                                padding: const EdgeInsets.all(CupertinoSpacing.s),
                                decoration: BoxDecoration(
                                  color: isPreviewed
                                      ? CupertinoColors.activeBlue.withValues(alpha: 0.1)
                                      : CupertinoColors.systemFill.resolveFrom(context),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  CupertinoIcons.info,
                                  color: isPreviewed
                                      ? CupertinoColors.activeBlue
                                      : CupertinoColors.secondaryLabel.resolveFrom(context),
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: CupertinoSpacing.m),
                            Text(
                              formatWithCurrency(item.amount, 'IDR'),
                              style: context.body.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.label.resolveFrom(context),
                                ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),

        // Sticky Bottom Panel
        CupertinoGlassContainer(
          borderRadius: 0,
          padding: const EdgeInsets.all(CupertinoSpacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedInvoices.length} tagihan dipilih',
                    style: context.subhead.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatWithCurrency(_totalAmount, 'IDR'),
                    style: context.title3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: CupertinoSpacing.m),

              // Date Picker Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tanggal Permintaan',
                    style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel),
                  ),
                  GestureDetector(
                    onTap: () => _showDatePicker(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.s),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemFill.resolveFrom(context),
                        borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy').format(_requestDate),
                            style: context.body.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: CupertinoSpacing.xs),
                          const Icon(
                            CupertinoIcons.calendar,
                            size: 16,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: CupertinoSpacing.m),

              // Description
              CupertinoTextField(
                controller: _descriptionController,
                placeholder: 'Masukkan deskripsi atau catatan tambahan...',
                maxLines: 2,
                padding: const EdgeInsets.all(CupertinoSpacing.s),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                  border: Border.all(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: CupertinoSpacing.l),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: CupertinoSpacing.primaryButtonHeight,
                child: CupertinoButton(
                  color: CupertinoColors.activeBlue,
                  disabledColor: CupertinoColors.inactiveGray.withValues(alpha: 0.5),
                  padding: EdgeInsets.zero,
                  onPressed: _selectedInvoices.isEmpty || _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                      : const Text(
                          'Buat Permintaan Pembayaran',
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
      ],
    );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Buat Permintaan',
          style: TextStyle(color: labelColor),
        ),
      ),
      child: SafeArea(
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 440,
                    child: mainListColumn,
                  ),
                  const VerticalDivider(width: 1, thickness: 0.5, color: CupertinoColors.separator),
                  Expanded(
                    child: _activePreviewInvoice != null
                        ? Container(
                            color: CupertinoColors.systemBackground.resolveFrom(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.l, vertical: CupertinoSpacing.m),
                                  color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rincian Tagihan',
                                        style: context.headline.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        child: const Icon(CupertinoIcons.clear),
                                        onPressed: () => setState(() => _activePreviewInvoice = null),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 0.5, thickness: 0.5, color: CupertinoColors.separator),
                                Expanded(
                                  child: InvoiceDetailPreview(
                                    key: ValueKey('${_activePreviewInvoice!.type}_${_activePreviewInvoice!.id}'),
                                    id: _activePreviewInvoice!.id,
                                    type: _activePreviewInvoice!.type,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Pilih ikon info pada tagihan untuk melihat rincian di sini.',
                              style: TextStyle(color: CupertinoColors.secondaryLabel),
                            ),
                          ),
                  ),
                ],
              )
            : mainListColumn,
      ),
    );
  }
}

class InvoiceDetailPreview extends ConsumerWidget {
  final int id;
  final String type;

  const InvoiceDetailPreview({
    super.key,
    required this.id,
    required this.type,
  });

  double doubleFromJson(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(invoiceDetailPreviewProvider(id: id, type: type));

    return previewAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(CupertinoSpacing.xxl),
          child: CupertinoActivityIndicator(),
        ),
      ),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(CupertinoSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gagal memuat rincian: $err', style: context.subhead),
              const SizedBox(height: CupertinoSpacing.s),
              CupertinoButton(
                child: const Text('Coba Lagi'),
                onPressed: () => ref.invalidate(invoiceDetailPreviewProvider(id: id, type: type)),
              ),
            ],
          ),
        ),
      ),
      data: (data) {
        return Scrollbar(
          child: ListView(
            padding: const EdgeInsets.all(CupertinoSpacing.l),
            children: [
              _buildHeader(context, data),
              const SizedBox(height: CupertinoSpacing.l),
              _buildBreakdown(context, data),
              const SizedBox(height: CupertinoSpacing.l),
              _buildItemsList(context, data),
              if (data['notes'] != null || data['description'] != null) ...[
                const SizedBox(height: CupertinoSpacing.l),
                _buildNotes(context, data),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> data) {
    final number = data['invoice_number'] ?? data['reference_number'] ?? '-';
    final typeLabel = type == 'supplier'
        ? 'Faktur Supplier'
        : type == 'biaya'
            ? 'Invoice Biaya'
            : 'Biaya Tambahan';
    final supplierName = data['supplier_name'] ?? (data['supplier']?['name']) ?? 'Unknown';

    final tglTerbit = data['invoice_date'] ?? data['posting_date'] ?? '-';
    final tglJatuhTempo = data['due_date'] ?? data['posting_date'] ?? '-';

    return Container(
      padding: const EdgeInsets.all(CupertinoSpacing.m),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  number,
                  style: context.title3.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: CupertinoSpacing.s),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: 2),
                decoration: BoxDecoration(
                  color: type == 'supplier'
                      ? const Color(0xFF007AFF)
                      : type == 'biaya'
                          ? const Color(0xFFFF9500)
                          : const Color(0xFF34C759),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  typeLabel,
                  style: context.caption2.copyWith(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.m),
          _buildRowDetail(context, 'Supplier', supplierName),
          const SizedBox(height: CupertinoSpacing.s),
          _buildRowDetail(context, 'Tgl Terbit', tglTerbit),
          const SizedBox(height: CupertinoSpacing.s),
          _buildRowDetail(context, 'Tgl Jatuh Tempo', tglJatuhTempo),
        ],
      ),
    );
  }

  Widget _buildRowDetail(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.subhead.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdown(BuildContext context, Map<String, dynamic> data) {
    final amount = doubleFromJson(data['amount']);
    final tax = doubleFromJson(data['tax_amount']);
    final total = doubleFromJson(data['total_amount']);

    return Container(
      padding: const EdgeInsets.all(CupertinoSpacing.m),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Keuangan',
            style: context.headline.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: CupertinoSpacing.m),
          if (type != 'landed_cost') ...[
            _buildRowAmount(context, 'Subtotal', amount),
            const SizedBox(height: CupertinoSpacing.s),
            _buildRowAmount(context, 'Pajak', tax),
            const SizedBox(height: CupertinoSpacing.s),
            const Divider(height: 0.5, thickness: 0.5),
            const SizedBox(height: CupertinoSpacing.s),
          ],
          _buildRowAmount(context, 'Total Tagihan', total, isBold: true, color: CupertinoColors.activeBlue),
        ],
      ),
    );
  }

  Widget _buildRowAmount(BuildContext context, String label, double val, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.subhead.copyWith(
            color: isBold ? CupertinoColors.label.resolveFrom(context) : CupertinoColors.secondaryLabel,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          formatWithCurrency(val, 'IDR'),
          style: context.subhead.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? CupertinoColors.label.resolveFrom(context),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList(BuildContext context, Map<String, dynamic> data) {
    if (type == 'supplier') {
      final items = data['items'] as List<dynamic>? ?? [];
      return _buildSectionContainer(
        context,
        title: 'Daftar Barang',
        child: items.isEmpty
            ? const Text('Tidak ada barang.')
            : Column(
                children: items.map((item) {
                  final productName = item['product_name'] ?? (item['product']?['name']) ?? 'Unknown';
                  final qty = doubleFromJson(item['quantity']);
                  final unit = item['unit'] ?? 'Unit';
                  final price = doubleFromJson(item['unit_price']);
                  final sub = doubleFromJson(item['subtotal'] ?? item['amount']);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName,
                                style: context.subhead.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: CupertinoSpacing.xs),
                              Text(
                                '$qty $unit @ ${formatWithCurrency(price, 'IDR')}',
                                style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: CupertinoSpacing.s),
                        Text(
                          formatWithCurrency(sub, 'IDR'),
                          style: context.subhead.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      );
    } else if (type == 'landed_cost') {
      final comps = data['components'] as List<dynamic>? ?? [];
      return _buildSectionContainer(
        context,
        title: 'Komponen Biaya',
        child: comps.isEmpty
            ? const Text('Tidak ada komponen.')
            : Column(
                children: comps.map((comp) {
                  final cat = comp['category'] ?? '-';
                  final amt = doubleFromJson(comp['amount']);
                  final refType = comp['ref_type'] == 'invoice' ? 'Invoice' : 'Packing List';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat,
                              style: context.subhead.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: CupertinoSpacing.xs),
                            Text(
                              'Sumber: $refType',
                              style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel),
                            ),
                          ],
                        ),
                        Text(
                          formatWithCurrency(amt, 'IDR'),
                          style: context.subhead.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSectionContainer(BuildContext context, {required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CupertinoSpacing.m),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.headline.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: CupertinoSpacing.m),
          child,
        ],
      ),
    );
  }

  Widget _buildNotes(BuildContext context, Map<String, dynamic> data) {
    final noteText = data['notes'] ?? data['description'] ?? '-';
    return _buildSectionContainer(
      context,
      title: 'Catatan Tagihan',
      child: Text(
        noteText,
        style: context.subhead,
      ),
    );
  }
}
