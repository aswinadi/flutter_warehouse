import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Colors, Scrollbar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/landed_cost.dart';
import '../providers/landed_cost_repository.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/models/company.dart';
import '../../purchase_request/models/supplier.dart';
import '../models/inventory.dart';
import '../../invoice/models/invoice.dart';
import '../../invoice/providers/invoice_repository.dart';
import '../../packing_list/models/packing_list.dart';
import '../../packing_list/providers/packing_list_provider.dart';
import '../../receiving/models/receiving.dart';
import '../../receiving/providers/receiving_provider.dart';
import '../../inventory/providers/asset_repository.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../../core/utils/currency_utils.dart';

class LandedCostFormScreen extends ConsumerStatefulWidget {
  final int? landedCostId;
  const LandedCostFormScreen({super.key, this.landedCostId});

  @override
  ConsumerState<LandedCostFormScreen> createState() => _LandedCostFormScreenState();
}

class _LandedCostFormScreenState extends ConsumerState<LandedCostFormScreen> {
  int _currentStep = 1; // 1: General Info, 2: Cost Components, 3: Allocation Matrix
  bool _isLoading = false;

  // Step 1 Controllers/State
  Company? _selectedCompany;
  Supplier? _selectedSupplier;
  DateTime _postingDate = DateTime.now();
  final _descriptionController = TextEditingController();

  // Step 2 State
  final List<Map<String, dynamic>> _componentInputs = [];

  // Step 3 State (resolved from API)
  LandedCost? _currentLandedCost;

  // Matrix edit controllers
  final Map<int, TextEditingController> _shipmentPctControllers = {};
  final Map<int, TextEditingController> _itemPctControllers = {};
  final Map<int, bool> _itemSelections = {};

  @override
  void initState() {
    super.initState();
    if (widget.landedCostId != null) {
      _loadLandedCostForEditing();
    } else {
      final activeCompany = ref.read(selectedCompanyProvider);
      if (activeCompany != null) {
        _selectedCompany = activeCompany;
      }
      
      // Start with one default empty component
      _componentInputs.add({
        'category': 'transport',
        'amount': 0.0,
        'ref_type': 'packing_list',
        'container': null,
        'invoice': null,
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    for (final controller in _shipmentPctControllers.values) {
      controller.dispose();
    }
    for (final controller in _itemPctControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadLandedCostForEditing() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(landedCostRepositoryProvider);
      final detail = await repo.getLandedCostDetail(widget.landedCostId!);

      // Load companies & suppliers first
      final companies = await ref.read(companiesProvider.future);
      final suppliers = await ref.read(assetSuppliersProvider(companyId: null).future);

      setState(() {
        _currentLandedCost = detail;
        _selectedCompany = companies.firstWhere((c) => c.id == detail.companyId, orElse: () => companies.first);
        _selectedSupplier = suppliers.firstWhere((s) => s.code == detail.supplierCode, orElse: () => suppliers.first);
        _postingDate = DateTime.parse(detail.postingDate);
        _descriptionController.text = detail.description ?? '';

        _componentInputs.clear();
        if (detail.components != null) {
          for (final comp in detail.components!) {
            _componentInputs.add({
              'category': comp.category,
              'amount': comp.amount,
              'ref_type': comp.refType ?? (comp.containerId != null ? 'packing_list' : 'invoice'),
              'container': comp.container != null
                  ? PackingList(id: comp.containerId!, containerNumber: comp.container!.containerNumber, status: '')
                  : null,
              'invoice': comp.invoice != null
                  ? Invoice(id: comp.invoiceId!, invoiceNumber: comp.invoice!.invoiceNumber, companyId: detail.companyId, status: '', totalAmount: 0, currency: 'IDR', invoiceDate: '', dueDate: '', subtotal: 0, taxAmount: 0, discountAmount: 0)
                  : null,
            });
          }
        }

        // If the landed cost is already saved, we can pre-populate the controllers for Step 3
        _initializeAllocationControllers(detail);
      });
    } catch (e) {
      _showError('Gagal memuat landed cost: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _initializeAllocationControllers(LandedCost landedCost) {
    _shipmentPctControllers.clear();
    _itemPctControllers.clear();
    _itemSelections.clear();

    if (landedCost.shipments != null) {
      for (final shipment in landedCost.shipments!) {
        _shipmentPctControllers[shipment.id] = TextEditingController(
          text: shipment.shipmentPercentage % 1 == 0
              ? shipment.shipmentPercentage.toInt().toString()
              : shipment.shipmentPercentage.toString(),
        );

        if (shipment.items != null) {
          for (final item in shipment.items!) {
            _itemSelections[item.id] = item.isSelected;
            _itemPctControllers[item.id] = TextEditingController(
              text: item.itemPercentage % 1 == 0
                  ? item.itemPercentage.toInt().toString()
                  : item.itemPercentage.toString(),
            );
          }
        }
      }
    }
  }

  void _autoDistributeShipmentPercentages() {
    if (_currentLandedCost == null) return;
    final shipments = _currentLandedCost!.shipments ?? <LandedCostShipment>[];

    // Find active shipments (those with at least one selected item)
    final activeShipments = shipments.where((s) {
      final items = s.items ?? <LandedCostItem>[];
      return items.any((it) => _itemSelections[it.id] ?? false);
    }).toList();

    if (activeShipments.isEmpty) {
      // Set all to 0
      for (final s in shipments) {
        final ctrl = _shipmentPctControllers[s.id];
        ctrl?.text = '0';
      }
      return;
    }

    final defaultPct = (100.0 / activeShipments.length).round();
    int allocated = 0;

    for (final s in shipments) {
      final ctrl = _shipmentPctControllers[s.id];
      final isActive = activeShipments.any((active) => active.id == s.id);

      if (!isActive) {
        ctrl?.text = '0';
      } else {
        // If it's the last active shipment, give it the remainder
        if (s.id == activeShipments.last.id) {
          ctrl?.text = (100 - allocated).toString();
        } else {
          ctrl?.text = defaultPct.toString();
          allocated += defaultPct;
        }
      }
    }
  }

  void _autoDistributeItemPercentages(LandedCostShipment shipment) {
    final items = shipment.items ?? <LandedCostItem>[];
    final selectedItems = items.where((it) => _itemSelections[it.id] ?? false).toList();

    if (selectedItems.isEmpty) {
      for (final it in items) {
        final ctrl = _itemPctControllers[it.id];
        ctrl?.text = '0';
      }
      return;
    }

    final defaultPct = (100.0 / selectedItems.length).round();
    int allocated = 0;

    for (final it in items) {
      final ctrl = _itemPctControllers[it.id];
      final isSel = _itemSelections[it.id] ?? false;

      if (!isSel) {
        ctrl?.text = '0';
      } else {
        if (it.id == selectedItems.last.id) {
          ctrl?.text = (100 - allocated).toString();
        } else {
          ctrl?.text = defaultPct.toString();
          allocated += defaultPct;
        }
      }
    }
  }

  void _showError(String msg) {
    if (mounted) {
      CupertinoGlassToast.showError(context, msg);
    }
  }

  Future<void> _selectPostingDate() async {
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
                initialDateTime: _postingDate,
                onDateTimeChanged: (val) {
                  setState(() {
                    _postingDate = val;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 2 Actions
  void _addComponent() {
    setState(() {
      _componentInputs.add({
        'category': 'transport',
        'amount': 0.0,
        'ref_type': 'packing_list',
        'container': null,
        'invoice': null,
      });
    });
  }

  void _removeComponent(int index) {
    if (_componentInputs.length == 1) {
      _showError('Minimal harus ada 1 cost component.');
      return;
    }
    setState(() {
      _componentInputs.removeAt(index);
    });
  }

  double get _totalCostPool {
    return _componentInputs.fold(0.0, (sum, comp) => sum + (comp['amount'] ?? 0.0));
  }

  // Step Transitions
  Future<void> _goToNextStep() async {
    if (_currentStep == 1) {
      if (_selectedCompany == null) {
        _showError('Silakan pilih Perusahaan.');
        return;
      }
      if (_selectedSupplier == null) {
        _showError('Silakan pilih Pemasok.');
        return;
      }
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      // Validate cost components
      for (int i = 0; i < _componentInputs.length; i++) {
        final comp = _componentInputs[i];
        final amount = comp['amount'];
        if (amount == null || amount <= 0) {
          _showError('Komponen ke-${i + 1}: Masukkan nilai biaya yang valid.');
          return;
        }
        if (comp['ref_type'] == 'packing_list' && comp['container'] == null) {
          _showError('Komponen ke-${i + 1}: Silakan pilih Packing List.');
          return;
        }
        if (comp['ref_type'] == 'invoice' && comp['invoice'] == null) {
          _showError('Komponen ke-${i + 1}: Silakan pilih Invoice.');
          return;
        }
      }

      // Save draft landed cost on backend
      setState(() => _isLoading = true);
      try {
        final repo = ref.read(landedCostRepositoryProvider);
        final postingDateStr = DateFormat('yyyy-MM-dd').format(_postingDate);

        final payload = {
          'company_id': _selectedCompany!.id,
          'posting_date': postingDateStr,
          'supplier_code': _selectedSupplier!.code,
          'supplier_name': _selectedSupplier!.name,
          'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
          'components': _componentInputs.map((comp) {
            return {
              'category': comp['category'],
              'amount': comp['amount'],
              'ref_type': comp['ref_type'],
              'container_id': comp['ref_type'] == 'packing_list' ? comp['container']?.id : null,
              'invoice_id': comp['ref_type'] == 'invoice' ? comp['invoice']?.id : null,
            };
          }).toList(),
        };

        LandedCost result;
        if (widget.landedCostId == null && _currentLandedCost == null) {
          result = await repo.createLandedCost(payload);
        } else {
          final id = widget.landedCostId ?? _currentLandedCost!.id;
          result = await repo.updateLandedCost(id, payload);
        }

        // Fetch detail to get resolved shipments & items
        final detail = await repo.getLandedCostDetail(result.id);

        setState(() {
          _currentLandedCost = detail;
          _initializeAllocationControllers(detail);
          _currentStep = 3;
        });
      } catch (e) {
        _showError('Gagal menyimpan draft: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Pre-calculate all shipment pools and item portions to handle rounding remainders
  Map<int, double> _calculateAllItemAllocations() {
    final allocations = <int, double>{};
    if (_currentLandedCost == null) return allocations;

    final shipments = _currentLandedCost!.shipments ?? <LandedCostShipment>[];
    final totalPool = _totalCostPool.round();

    // Filter active shipments (those with at least one selected item)
    final activeShipments = shipments.where((s) {
      final items = s.items ?? <LandedCostItem>[];
      return items.any((it) => _itemSelections[it.id] ?? false);
    }).toList();

    // 1. Calculate shipment pools
    double totalShipmentPct = 0.0;
    for (final s in activeShipments) {
      final ctrl = _shipmentPctControllers[s.id];
      totalShipmentPct += double.tryParse(ctrl?.text ?? '') ?? 0.0;
    }
    if (totalShipmentPct == 0.0) totalShipmentPct = 100.0;

    final shipmentPools = <int, int>{};
    int totalAllocatedShipments = 0;

    for (int i = 0; i < activeShipments.length; i++) {
      final shipment = activeShipments[i];
      if (i == activeShipments.length - 1) {
        shipmentPools[shipment.id] = totalPool - totalAllocatedShipments;
      } else {
        final ctrl = _shipmentPctControllers[shipment.id];
        final pct = double.tryParse(ctrl?.text ?? '') ?? 0.0;
        final portion = ((pct / totalShipmentPct) * totalPool).round();
        shipmentPools[shipment.id] = portion;
        totalAllocatedShipments += portion;
      }
    }

    // 2. Calculate item portions in each shipment
    for (final shipment in shipments) {
      final shipmentPool = shipmentPools[shipment.id] ?? 0;
      final items = shipment.items ?? <LandedCostItem>[];

      final selectedItems = items.where((it) => _itemSelections[it.id] ?? false).toList();
      double totalItemPct = 0.0;
      for (final it in selectedItems) {
        final ctrl = _itemPctControllers[it.id];
        totalItemPct += double.tryParse(ctrl?.text ?? '') ?? 0.0;
      }
      if (totalItemPct == 0.0) totalItemPct = 100.0;

      int totalAllocatedItems = 0;
      for (int j = 0; j < selectedItems.length; j++) {
        final item = selectedItems[j];
        if (j == selectedItems.length - 1) {
          allocations[item.id] = (shipmentPool - totalAllocatedItems).toDouble();
        } else {
          final ctrl = _itemPctControllers[item.id];
          final pct = double.tryParse(ctrl?.text ?? '') ?? 0.0;
          final portion = ((pct / totalItemPct) * shipmentPool).round();
          allocations[item.id] = portion.toDouble();
          totalAllocatedItems += portion;
        }
      }
    }

    return allocations;
  }

  // Calculate live preview in step 3
  double _calculateNewHpp(LandedCostItem item, LandedCostShipment shipment, Map<int, double> allocations) {
    if (!item.isSelected || item.receivedQty <= 0) {
      return item.originalPrice;
    }
    final itemCost = allocations[item.id] ?? 0.0;
    return item.originalPrice + (itemCost / item.receivedQty);
  }

  Future<void> _submitAllocation() async {
    if (_currentLandedCost == null) return;

    // Validation
    double totalShipmentPct = 0.0;
    final shipmentsPayload = <Map<String, dynamic>>[];

    for (final shipment in _currentLandedCost!.shipments ?? <LandedCostShipment>[]) {
      final ctrl = _shipmentPctControllers[shipment.id];
      final shipmentPct = double.tryParse(ctrl?.text ?? '') ?? 0.0;

      final itemsPayload = <Map<String, dynamic>>[];
      double totalItemPct = 0.0;
      bool hasSelectedItems = false;

      for (final item in shipment.items ?? <LandedCostItem>[]) {
        final isSel = _itemSelections[item.id] ?? false;
        final itemPctCtrl = _itemPctControllers[item.id];
        final itemPct = double.tryParse(itemPctCtrl?.text ?? '') ?? 0.0;

        if (isSel) {
          hasSelectedItems = true;
          totalItemPct += itemPct;
        }

        itemsPayload.add({
          'id': item.id,
          'is_selected': isSel,
          'item_percentage': isSel ? itemPct : 0.0,
        });
      }

      if (hasSelectedItems) {
        totalShipmentPct += shipmentPct;
        if ((totalItemPct - 100.0).abs() > 0.01) {
          _showError('Total persentase item yang dipilih pada pengiriman DO ${_currentShipmentLabel(shipment)} harus bernilai 100%. Total saat ini: $totalItemPct%');
          return;
        }
      }

      shipmentsPayload.add({
        'id': shipment.id,
        'shipment_percentage': hasSelectedItems ? shipmentPct : 0.0,
        'items': itemsPayload,
      });
    }

    if ((totalShipmentPct - 100.0).abs() > 0.01) {
      _showError('Total persentase alokasi pengiriman harus bernilai 100%. Total saat ini: $totalShipmentPct%');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(landedCostRepositoryProvider);
      await repo.allocateLandedCost(_currentLandedCost!.id, {
        'shipments': shipmentsPayload,
      });

      // Invalidate list provider to refresh lists
      ref.invalidate(landedCostListProvider);

      if (mounted) {
        CupertinoGlassToast.showSuccess(context, 'Alokasi berhasil disimpan, landed cost diajukan.');
        context.pop();
      }
    } catch (e) {
      _showError('Gagal menyimpan alokasi: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _currentShipmentLabel(LandedCostShipment s) {
    if (s.receivingHeader == null) return s.receivingHeaderId.toString();
    final header = s.receivingHeader!;
    return header.deliveryOrderNumber != null && header.deliveryOrderNumber!.isNotEmpty
        ? '${header.deliveryOrderNumber} (${header.receivingNumber})'
        : header.receivingNumber;
  }

  // Pickers & Form Widgets
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

  void _showSearchablePicker<T>({
    required String label,
    required List<T> items,
    required void Function(T) onSelected,
    required String Function(T) itemLabelBuilder,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _SearchablePickerModal<T>(
        label: label,
        items: items,
        onSelected: onSelected,
        itemLabelBuilder: itemLabelBuilder,
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
                      _showSearchablePicker<T>(
                        label: label,
                        items: items,
                        onSelected: onSelected,
                        itemLabelBuilder: itemLabelBuilder,
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

  @override
  Widget build(BuildContext context) {
    final companiesAsync = ref.watch(companiesProvider);
    final suppliersAsync = ref.watch(assetSuppliersProvider(companyId: _selectedCompany?.id));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final borderCol = CupertinoColors.separator.resolveFrom(context);

    String middleTitle = 'Step 1 of 3: Info Umum';
    if (_currentStep == 2) middleTitle = 'Step 2 of 3: Komponen Biaya';
    if (_currentStep == 3) middleTitle = 'Step 3 of 3: Matrix Alokasi';

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          middleTitle,
          style: TextStyle(color: labelColor),
        ),
        leading: _currentStep > 1
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => setState(() => _currentStep--),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.left_chevron, size: 20),
                    Text('Kembali'),
                  ],
                ),
              )
            : null,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoading
              ? null
              : (_currentStep == 3 ? _submitAllocation : _goToNextStep),
          child: Text(
            _currentStep == 3 ? 'Kirim' : 'Lanjut',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _buildStepContent(companiesAsync, suppliersAsync, labelColor, secondaryLabel, borderCol),
      ),
    );
  }

  Widget _buildStepContent(
    AsyncValue<List<Company>> companiesAsync,
    AsyncValue<List<Supplier>> suppliersAsync,
    Color labelColor,
    Color secondaryLabel,
    Color borderCol,
  ) {
    if (_currentStep == 1) {
      return ListView(
        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
        children: [
          Text(
            'Informasi Landed Cost',
            style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: secondaryLabel),
          ),
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
                  onSelected: widget.landedCostId != null
                      ? null // Disable editing in edit mode
                      : (c) {
                          setState(() {
                            _selectedCompany = c;
                            _selectedSupplier = null; // reset supplier when company changes
                          });
                        },
                  itemLabelBuilder: (c) => c.companyName,
                ),
                const Divider(color: CupertinoColors.separator, height: 16),
                _buildPickerRow<Supplier>(
                  label: 'Supplier / Transporter',
                  value: _selectedSupplier,
                  placeholder: _selectedCompany == null ? 'Pilih Perusahaan dulu' : 'Pilih Supplier...',
                  asyncValue: suppliersAsync,
                  onSelected: (s) {
                    setState(() {
                      _selectedSupplier = s;
                    });
                  },
                  itemLabelBuilder: (s) => '${s.code} - ${s.name}',
                ),
                const Divider(color: CupertinoColors.separator, height: 16),
                _buildFormRow(
                  label: 'Tanggal Posting',
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: _selectPostingDate,
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(_postingDate),
                        style: TextStyle(color: labelColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: CupertinoSpacing.xl),
          Text(
            'Keterangan / Catatan',
            style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: secondaryLabel),
          ),
          const SizedBox(height: CupertinoSpacing.s),
          CupertinoGlassContainer(
            borderRadius: CupertinoSpacing.cardRadius,
            padding: const EdgeInsets.all(CupertinoSpacing.m),
            child: CupertinoTextField(
              controller: _descriptionController,
              placeholder: 'Tambahkan catatan mengenai landed cost ini...',
              placeholderStyle: TextStyle(color: CupertinoColors.placeholderText.resolveFrom(context)),
              maxLines: 4,
              decoration: null,
              padding: EdgeInsets.zero,
              style: TextStyle(color: labelColor),
            ),
          ),
        ],
      );
    }

    if (_currentStep == 2) {
      final packingListsAsync = ref.watch(packingListsProvider(status: 'shipped,arrived,closed'));
      final invoicesAsync = ref.watch(invoicesProvider());

      return ListView(
        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Komponen Biaya Tambahan',
                style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: secondaryLabel),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _addComponent,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.add_circled, size: 18),
                    SizedBox(width: 4),
                    Text('Tambah', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),

          ..._componentInputs.asMap().entries.map((entry) {
            final idx = entry.key;
            final comp = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: CupertinoSpacing.m),
              child: CupertinoGlassContainer(
                borderRadius: CupertinoSpacing.cardRadius,
                padding: const EdgeInsets.all(CupertinoSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Komponen #${idx + 1}',
                          style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: secondaryLabel),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          onPressed: () => _removeComponent(idx),
                          child: const Icon(CupertinoIcons.trash, color: CupertinoColors.systemRed, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: CupertinoSpacing.s),
                    _buildFormRow(
                      label: 'Jenis Biaya',
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                title: const Text('Pilih Jenis Biaya'),
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        comp['category'] = 'labor';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Tenaga Kerja'),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        comp['category'] = 'shipping';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Pengiriman/Logistik'),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        comp['category'] = 'transport';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Transportasi'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(
                            comp['category'] == 'labor'
                                ? 'Tenaga Kerja'
                                : comp['category'] == 'shipping'
                                    ? 'Pengiriman/Logistik'
                                    : 'Transportasi',
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: CupertinoColors.separator, height: 16),
                    _buildFormRow(
                      label: 'Nilai Biaya (IDR)',
                      child: CupertinoTextField(
                        placeholder: '0.00',
                        placeholderStyle: TextStyle(color: CupertinoColors.placeholderText.resolveFrom(context)),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: null,
                        padding: EdgeInsets.zero,
                        style: TextStyle(color: labelColor),
                        controller: TextEditingController(
                          text: comp['amount'] > 0 ? comp['amount'].toString() : '',
                        )..addListener(() {
                            final val = double.tryParse(TextEditingController().text); // Wait, listener needs controller
                          }),
                        onChanged: (val) {
                          comp['amount'] = double.tryParse(val) ?? 0.0;
                        },
                      ),
                    ),
                    const Divider(color: CupertinoColors.separator, height: 16),
                    _buildFormRow(
                      label: 'Tipe Referensi',
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                title: const Text('Pilih Tipe Referensi'),
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        comp['ref_type'] = 'packing_list';
                                        comp['container'] = null;
                                        comp['invoice'] = null;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Packing List (Container)'),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        comp['ref_type'] = 'invoice';
                                        comp['container'] = null;
                                        comp['invoice'] = null;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Invoice'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(comp['ref_type'] == 'packing_list' ? 'Packing List' : 'Invoice'),
                        ),
                      ),
                    ),
                    const Divider(color: CupertinoColors.separator, height: 16),

                    if (comp['ref_type'] == 'packing_list')
                      _buildPickerRow<PackingList>(
                        label: 'Packing List',
                        value: comp['container'],
                        placeholder: 'Pilih Packing List...',
                        asyncValue: packingListsAsync,
                        onSelected: (p) {
                          setState(() {
                            comp['container'] = p;
                          });
                        },
                        itemLabelBuilder: (p) {
                          final buffer = StringBuffer(p.containerNumber);
                          final details = <String>[];
                          if (p.closingDate != null) {
                            final dateStr = DateFormat('dd-MM-yyyy').format(p.closingDate!);
                            details.add('Tgl Segel: $dateStr');
                          }
                          if (p.destinationWarehouseName != null && p.destinationWarehouseName!.isNotEmpty) {
                            details.add('Tujuan: ${p.destinationWarehouseName}');
                          }
                          if (p.carrierName != null && p.carrierName!.isNotEmpty) {
                            details.add('Pelayaran: ${p.carrierName}');
                          }
                          if (details.isNotEmpty) {
                            buffer.write('\n${details.join(' | ')}');
                          }
                          return buffer.toString();
                        },
                      )
                    else
                      _buildPickerRow<Invoice>(
                        label: 'Invoice',
                        value: comp['invoice'],
                        placeholder: 'Pilih Invoice...',
                        asyncValue: invoicesAsync,
                        onSelected: (inv) {
                          setState(() {
                            comp['invoice'] = inv;
                          });
                        },
                        itemLabelBuilder: (inv) => '${inv.invoiceNumber} - ${inv.supplierName ?? ""}',
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: CupertinoSpacing.l),
          CupertinoGlassContainer(
            borderRadius: CupertinoSpacing.cardRadius,
            padding: const EdgeInsets.all(CupertinoSpacing.m),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Cost Pool',
                  style: context.callout.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                ),
                Text(
                  formatWithCurrency(_totalCostPool, 'IDR'),
                  style: context.title3.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_currentStep == 3 && _currentLandedCost != null) {
      final shipments = _currentLandedCost!.shipments ?? <LandedCostShipment>[];
      final allocations = _calculateAllItemAllocations();

      double totalShipmentPct = 0.0;
      for (final s in shipments) {
        final items = s.items ?? <LandedCostItem>[];
        final isActive = items.any((it) => _itemSelections[it.id] ?? false);
        if (isActive) {
          final ctrl = _shipmentPctControllers[s.id];
          totalShipmentPct += double.tryParse(ctrl?.text ?? '') ?? 0.0;
        }
      }

      return Scrollbar(
        child: ListView(
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          children: [
            CupertinoGlassContainer(
              borderRadius: CupertinoSpacing.cardRadius,
              padding: const EdgeInsets.all(CupertinoSpacing.m),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Cost Pool', style: context.footnote.copyWith(color: secondaryLabel)),
                      Text(formatWithCurrency(_totalCostPool, 'IDR'), style: context.callout.copyWith(fontWeight: FontWeight.bold, color: labelColor)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: CupertinoSpacing.xl),
            Text(
              'Alokasi per Pengiriman (Shipment)',
              style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: secondaryLabel),
            ),
            const SizedBox(height: CupertinoSpacing.s),

            CupertinoGlassContainer(
              borderRadius: CupertinoSpacing.cardRadius,
              padding: const EdgeInsets.all(CupertinoSpacing.m),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Alokasi Pengiriman',
                    style: context.callout.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                  ),
                  Text(
                    '${totalShipmentPct.toStringAsFixed(1)}%',
                    style: context.callout.copyWith(
                      fontWeight: FontWeight.bold,
                      color: (totalShipmentPct - 100.0).abs() <= 0.01
                          ? CupertinoColors.systemGreen
                          : CupertinoColors.systemRed,
                    ),
                  ),
                ],
              ),
            ),
            if (totalShipmentPct > 100.0) ...[
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'Total alokasi pengiriman tidak boleh melebihi 100%!',
                  style: TextStyle(color: CupertinoColors.systemRed, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            const SizedBox(height: CupertinoSpacing.m),

            ...shipments.map((shipment) {
              bool hasSelectedItems = false;
              double totalItemPct = 0.0;
              for (final it in shipment.items ?? <LandedCostItem>[]) {
                final isSel = _itemSelections[it.id] ?? false;
                if (isSel) {
                  hasSelectedItems = true;
                  final ctrl = _itemPctControllers[it.id];
                  totalItemPct += double.tryParse(ctrl?.text ?? '') ?? 0.0;
                }
              }
              final shipmentLabel = _currentShipmentLabel(shipment);
              final pctCtrl = _shipmentPctControllers[shipment.id];

              return Padding(
                padding: const EdgeInsets.only(bottom: CupertinoSpacing.m),
                child: CupertinoGlassContainer(
                  borderRadius: CupertinoSpacing.cardRadius,
                  padding: const EdgeInsets.all(CupertinoSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              shipmentLabel,
                              style: context.callout.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: CupertinoTextField(
                              controller: pctCtrl,
                              enabled: hasSelectedItems,
                              placeholder: '0.00',
                              placeholderStyle: TextStyle(color: CupertinoColors.placeholderText.resolveFrom(context)),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              textAlign: TextAlign.right,
                              suffix: const Padding(
                                padding: EdgeInsets.only(right: 8.0, left: 4.0),
                                child: Text('%', style: TextStyle(fontWeight: FontWeight.w500)),
                              ),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemBackground.resolveFrom(context),
                                border: Border.all(color: borderCol, width: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              onChanged: (val) {
                                final parsed = double.tryParse(val) ?? 0.0;
                                if (parsed > 100.0 && pctCtrl != null) {
                                  pctCtrl.text = '100';
                                  pctCtrl.selection = TextSelection.fromPosition(
                                    TextPosition(offset: pctCtrl.text.length),
                                  );
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: CupertinoSpacing.m),
                      Text(
                        'Items checklist:',
                        style: context.caption1.copyWith(fontWeight: FontWeight.bold, color: secondaryLabel),
                      ),
                      const SizedBox(height: CupertinoSpacing.s),

                      ...?(shipment.items?.map((item) {
                        final isSel = _itemSelections[item.id] ?? false;
                        final itemPctCtrl = _itemPctControllers[item.id];
                        final details = item.receivingDetail;
                        final productName = details?.product?.name ?? 'Unknown';
                        final sku = details?.product?.sku ?? 'N/A';
                        final qty = details?.receivedQty ?? 0.0;
                        final unit = details?.unit ?? '-';
                        final originalPrice = details?.poDetail?.unitPrice ?? 0.0;
                        final newHpp = _calculateNewHpp(item, shipment, allocations);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  setState(() {
                                    _itemSelections[item.id] = !isSel;
                                    _autoDistributeItemPercentages(shipment);
                                    _autoDistributeShipmentPercentages();
                                  });
                                },
                                child: Icon(
                                  isSel ? CupertinoIcons.checkmark_square_fill : CupertinoIcons.square,
                                  color: isSel ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName,
                                      style: context.footnote.copyWith(fontWeight: FontWeight.w600, color: labelColor),
                                    ),
                                    Text(
                                      'SKU: $sku | Qty: $qty $unit',
                                      style: context.caption2.copyWith(color: secondaryLabel),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          'HPP: ${formatCurrency(originalPrice, "IDR")}',
                                          style: context.caption2.copyWith(color: secondaryLabel),
                                        ),
                                        const Icon(CupertinoIcons.right_chevron, size: 10, color: CupertinoColors.inactiveGray),
                                        Text(
                                          formatCurrency(newHpp, "IDR"),
                                          style: context.caption2.copyWith(color: CupertinoColors.systemGreen, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 80,
                                child: CupertinoTextField(
                                  controller: itemPctCtrl,
                                  enabled: isSel,
                                  placeholder: '0.00',
                                  placeholderStyle: TextStyle(color: CupertinoColors.placeholderText.resolveFrom(context)),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  textAlign: TextAlign.right,
                                  suffix: const Padding(
                                    padding: EdgeInsets.only(right: 6.0, left: 2.0),
                                    child: Text('%', style: TextStyle(fontSize: 11)),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSel
                                        ? CupertinoColors.systemBackground.resolveFrom(context)
                                        : CupertinoColors.inactiveGray.withValues(alpha: 0.1),
                                    border: Border.all(color: borderCol, width: 0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  onChanged: (val) {
                                    final parsed = double.tryParse(val) ?? 0.0;
                                    if (parsed > 100.0 && itemPctCtrl != null) {
                                      itemPctCtrl.text = '100';
                                      itemPctCtrl.selection = TextSelection.fromPosition(
                                        TextPosition(offset: itemPctCtrl.text.length),
                                      );
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      })),
                      const Divider(color: CupertinoColors.separator, height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Alokasi Item (Terpilih)',
                            style: context.caption1.copyWith(fontWeight: FontWeight.bold, color: secondaryLabel),
                          ),
                          Text(
                            '${totalItemPct.toStringAsFixed(1)}%',
                            style: context.caption1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: (totalItemPct - 100.0).abs() <= 0.01
                                  ? CupertinoColors.systemGreen
                                  : CupertinoColors.systemRed,
                            ),
                          ),
                        ],
                      ),
                      if (totalItemPct > 100.0) ...[
                        const SizedBox(height: 4),
                        const Text(
                          'Total alokasi item tidak boleh melebihi 100%!',
                          style: TextStyle(color: CupertinoColors.systemRed, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _SearchablePickerModal<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final void Function(T) onSelected;
  final String Function(T) itemLabelBuilder;

  const _SearchablePickerModal({
    super.key,
    required this.label,
    required this.items,
    required this.onSelected,
    required this.itemLabelBuilder,
  });

  @override
  State<_SearchablePickerModal<T>> createState() => _SearchablePickerModalState<T>();
}

class _SearchablePickerModalState<T> extends State<_SearchablePickerModal<T>> {
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final label = widget.itemLabelBuilder(item).toLowerCase();
          return label.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final bgColor = isDark
        ? CupertinoColors.systemBackground.resolveFrom(context)
        : CupertinoColors.white;

    return Container(
      height: mediaQuery.size.height * 0.7,
      margin: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pilih ${widget.label}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoSearchTextField(
                placeholder: 'Cari...',
                onChanged: _filter,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada data ditemukan',
                        style: TextStyle(color: CupertinoColors.secondaryLabel),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final label = widget.itemLabelBuilder(item);
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: CupertinoColors.separator.resolveFrom(context),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: CupertinoButton(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            onPressed: () {
                              widget.onSelected(item);
                              Navigator.pop(context);
                            },
                            child: Text(
                              label,
                              style: TextStyle(
                                color: CupertinoColors.label.resolveFrom(context),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

