import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/asset.dart';
import '../providers/asset_repository.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/models/company.dart';
import '../../../core/config/app_config.dart';
import '../../purchase_request/models/supplier.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

class EditAssetScreen extends ConsumerStatefulWidget {
  final int assetId;
  const EditAssetScreen({super.key, required this.assetId});

  @override
  ConsumerState<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends ConsumerState<EditAssetScreen> {
  bool _isSubmitting = false;
  bool _initialized = false;

  // Form Fields
  Company? _selectedCompany;
  String? _selectedCategory;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();

  DateTime? _purchaseDate;
  final TextEditingController _purchasePriceController = TextEditingController();
  Supplier? _selectedSupplier;
  DateTime? _warrantyExpiry;

  String _status = 'available';
  AssetEmployee? _selectedEmployee;
  AssetOffice? _selectedOffice;
  DateTime? _assignedDate;

  final TextEditingController _specificationsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  XFile? _photoFile;
  final ImagePicker _picker = ImagePicker();

  // Field validation messages
  String? _companyError;
  String? _categoryError;
  String? _nameError;

  final List<String> _categories = [
    'Laptop',
    'Desktop',
    'Monitor',
    'Camera',
    'Printer',
    'Networking',
    'Mobile',
    'Audio/Video',
    'Peripheral',
    'Other'
  ];

  final List<Map<String, String>> _statuses = [
    {'value': 'available', 'label': 'Available'},
    {'value': 'assigned', 'label': 'Assigned'},
    {'value': 'maintenance', 'label': 'In Maintenance'},
    {'value': 'retired', 'label': 'Retired'},
    {'value': 'broken', 'label': 'Broken'},
    {'value': 'lost', 'label': 'Lost'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _serialNumberController.dispose();
    _purchasePriceController.dispose();
    _specificationsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeFields(Asset asset, List<Company> companies) {
    _nameController.text = asset.name;
    _brandController.text = asset.brand ?? '';
    _modelController.text = asset.model ?? '';
    _serialNumberController.text = asset.serialNumber ?? '';
    _purchasePriceController.text = asset.purchasePrice ?? '';
    _specificationsController.text = asset.specifications ?? '';
    _notesController.text = asset.notes ?? '';
    _status = asset.status;
    _purchaseDate = asset.purchaseDate != null && asset.purchaseDate!.isNotEmpty ? DateTime.tryParse(asset.purchaseDate!) : null;
    _warrantyExpiry = asset.warrantyExpiry != null && asset.warrantyExpiry!.isNotEmpty ? DateTime.tryParse(asset.warrantyExpiry!) : null;
    _assignedDate = asset.assignedDate != null && asset.assignedDate!.isNotEmpty ? DateTime.tryParse(asset.assignedDate!) : null;

    // Resolve company from list
    try {
      _selectedCompany = companies.firstWhere((c) => c.id == asset.companyId);
    } catch (_) {
      _selectedCompany = Company(id: asset.companyId, companyName: asset.companyName ?? '', companyCode: '');
    }

    if (asset.employeeId != null) {
      _selectedEmployee = AssetEmployee(id: asset.employeeId!, fullName: asset.employeeName ?? '', companyId: asset.companyId);
    }
    if (asset.officeId != null) {
      _selectedOffice = AssetOffice(id: asset.officeId!, officeName: asset.officeName ?? '', companyId: asset.companyId);
    }
    if (asset.supplierId != null) {
      _selectedSupplier = Supplier(id: asset.supplierId!, name: asset.supplierName ?? '');
    }

    // Match category if it exists in the categories list
    if (_categories.contains(asset.category)) {
      _selectedCategory = asset.category;
    } else {
      _selectedCategory = 'Other';
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _photoFile = pickedFile;
        });
      }
    } catch (e) {
      CupertinoGlassToast.showError(context, 'Gagal mengambil gambar: $e');
    }
  }

  void _showCupertinoDatePicker({
    required DateTime initialDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
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
                        onDateSelected(tempDate);
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

  void _showCompanyPicker(List<Company> companies) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Perusahaan'),
        actions: companies.map((c) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedCompany = c;
                _selectedOffice = null;
                _selectedEmployee = null;
                _selectedSupplier = null;
                _companyError = null;
              });
              Navigator.pop(context);
            },
            child: Text(c.companyName),
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

  void _showCategoryPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Kategori'),
        actions: _categories.map((cat) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedCategory = cat;
                _categoryError = null;
              });
              Navigator.pop(context);
            },
            child: Text(cat),
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

  void _showStatusPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Status Aset'),
        actions: _statuses.map((stat) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _status = stat['value']!;
              });
              Navigator.pop(context);
            },
            child: Text(stat['label']!),
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

  void _showEmployeePicker(List<AssetEmployee> employees) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Karyawan / Pengguna'),
        actions: employees.map((emp) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedEmployee = emp;
              });
              Navigator.pop(context);
            },
            child: Text(emp.fullName),
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

  void _showOfficePicker(List<AssetOffice> offices) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Lokasi Kantor'),
        actions: offices.map((off) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedOffice = off;
              });
              Navigator.pop(context);
            },
            child: Text(off.officeName),
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

  void _showSupplierPicker(List<Supplier> suppliers) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Supplier'),
        actions: suppliers.map((sup) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedSupplier = sup;
              });
              Navigator.pop(context);
            },
            child: Text(sup.name),
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

  void _showPhotoSourceSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Lampirkan Foto Aset'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: const Text('Ambil Foto dari Kamera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: const Text('Pilih Foto dari Galeri'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    bool hasError = false;

    if (_selectedCompany == null) {
      setState(() => _companyError = 'Perusahaan wajib dipilih');
      hasError = true;
    }
    if (_selectedCategory == null) {
      setState(() => _categoryError = 'Kategori wajib dipilih');
      hasError = true;
    }
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Nama aset wajib diisi');
      hasError = true;
    }

    if (hasError) {
      CupertinoGlassToast.showError(context, 'Harap lengkapi semua kolom wajib.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final Map<String, dynamic> data = {
        'company_id': _selectedCompany!.id,
        'category': _selectedCategory!,
        'name': _nameController.text.trim(),
        'brand': _brandController.text.trim(),
        'model': _modelController.text.trim(),
        'serial_number': _serialNumberController.text.trim(),
        'status': _status,
        if (_purchaseDate != null) 'purchase_date': DateFormat('yyyy-MM-dd').format(_purchaseDate!),
        if (_purchasePriceController.text.isNotEmpty) 'purchase_price': _purchasePriceController.text.trim(),
        if (_selectedSupplier != null) 'supplier_id': _selectedSupplier!.id,
        if (_warrantyExpiry != null) 'warranty_expiry': DateFormat('yyyy-MM-dd').format(_warrantyExpiry!),
        if (_selectedEmployee != null) 'employee_id': _selectedEmployee!.id,
        if (_selectedOffice != null) 'office_id': _selectedOffice!.id,
        if (_assignedDate != null) 'assigned_date': DateFormat('yyyy-MM-dd').format(_assignedDate!),
        'specifications': _specificationsController.text.trim(),
        'notes': _notesController.text.trim(),
      };

      await ref.read(assetRepositoryProvider).updateAsset(widget.assetId, data, photoFile: _photoFile);

      CupertinoGlassToast.showSuccess(context, 'Aset hardware berhasil diperbarui.');
      ref.invalidate(assetDetailProvider(widget.assetId)); // Refresh detail
      ref.invalidate(assetListProvider); // Refresh list
      
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      CupertinoGlassToast.showError(context, 'Gagal memperbarui aset: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetAsync = ref.watch(assetDetailProvider(widget.assetId));
    final companiesAsync = ref.watch(companiesProvider);

    return assetAsync.when(
      data: (asset) {
        return companiesAsync.when(
          data: (companies) {
            if (!_initialized) {
              _initializeFields(asset, companies);
              _initialized = true;
            }

            final officesAsync = _selectedCompany != null
                ? ref.watch(assetOfficesProvider(companyId: _selectedCompany!.id))
                : const AsyncValue<List<AssetOffice>>.data([]);
            final employeesAsync = _selectedCompany != null
                ? ref.watch(assetEmployeesProvider(companyId: _selectedCompany!.id))
                : const AsyncValue<List<AssetEmployee>>.data([]);
            final suppliersAsync = ref.watch(assetSuppliersProvider(companyId: null));

            return CupertinoPageScaffold(
              backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
              navigationBar: const CupertinoNavigationBar(
                middle: Text('Edit Aset Hardware'),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Identification Section
                      _buildSectionTitle('Identifikasi Aset'),
                      CupertinoGlassContainer(
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Company Display (Readonly or selector depending on user need, keeping selector as per Add screen)
                            _buildSelectField(
                              label: 'Perusahaan *',
                              value: _selectedCompany != null ? _selectedCompany!.companyName : 'Pilih Perusahaan',
                              onTap: () => _showCompanyPicker(companies),
                            ),
                            if (_companyError != null) ...[
                              const SizedBox(height: CupertinoSpacing.xs),
                              Text(_companyError!, style: context.caption1.copyWith(color: CupertinoColors.destructiveRed)),
                            ],
                            const SizedBox(height: CupertinoSpacing.l),

                            // Category Select Field
                            _buildSelectField(
                              label: 'Kategori *',
                              value: _selectedCategory ?? 'Pilih Kategori',
                              onTap: _showCategoryPicker,
                            ),
                            if (_categoryError != null) ...[
                              const SizedBox(height: CupertinoSpacing.xs),
                              Text(_categoryError!, style: context.caption1.copyWith(color: CupertinoColors.destructiveRed)),
                            ],
                            const SizedBox(height: CupertinoSpacing.l),

                            // Asset Name
                            Text('Nama Aset *', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: CupertinoSpacing.s),
                            CupertinoTextField(
                              controller: _nameController,
                              placeholder: 'Misal: MacBook Pro M3 Max 16"',
                              onChanged: (val) {
                                if (val.trim().isNotEmpty && _nameError != null) {
                                  setState(() => _nameError = null);
                                }
                              },
                            ),
                            if (_nameError != null) ...[
                              const SizedBox(height: CupertinoSpacing.xs),
                              Text(_nameError!, style: context.caption1.copyWith(color: CupertinoColors.destructiveRed)),
                            ],
                            const SizedBox(height: CupertinoSpacing.l),

                            // Brand & Model
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Brand', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
                                      const SizedBox(height: CupertinoSpacing.s),
                                      CupertinoTextField(
                                        controller: _brandController,
                                        placeholder: 'Apple',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: CupertinoSpacing.l),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Model', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
                                      const SizedBox(height: CupertinoSpacing.s),
                                      CupertinoTextField(
                                        controller: _modelController,
                                        placeholder: 'A2991',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: CupertinoSpacing.l),

                            // Serial Number
                            Text('Serial Number (S/N)', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: CupertinoSpacing.s),
                            CupertinoTextField(
                              controller: _serialNumberController,
                              placeholder: 'C02XG8...',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: CupertinoSpacing.xl),

                      // 2. Acquisition Section
                      _buildSectionTitle('Pembelian & Garansi'),
                      CupertinoGlassContainer(
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Purchase Date
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _purchaseDate == null
                                        ? 'Tanggal Beli: Belum Dipilih'
                                        : 'Tanggal Beli: ${DateFormat('dd-MM-yyyy').format(_purchaseDate!)}',
                                    style: context.subhead.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
                                  child: const Text('Pilih', style: TextStyle(color: Color(0xFF6E56CF))),
                                  onPressed: () => _showCupertinoDatePicker(
                                    initialDate: _purchaseDate ?? DateTime.now(),
                                    onDateSelected: (date) => setState(() => _purchaseDate = date),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: CupertinoSpacing.s),
                            
                            // Purchase Price
                            Text('Harga Beli (IDR)', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: CupertinoSpacing.s),
                            CupertinoTextField(
                              controller: _purchasePriceController,
                              placeholder: 'Misal: 15000000',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                            const SizedBox(height: CupertinoSpacing.l),

                            // Supplier Select Field
                            suppliersAsync.when(
                              data: (suppliers) => _buildSelectField(
                                label: 'Supplier',
                                value: _selectedSupplier != null ? _selectedSupplier!.name : 'Pilih Supplier',
                                onTap: () => _showSupplierPicker(suppliers),
                              ),
                              loading: () => const Center(child: CupertinoActivityIndicator()),
                              error: (err, _) => Text('Gagal memuat supplier: $err', style: const TextStyle(color: CupertinoColors.destructiveRed)),
                            ),
                            const SizedBox(height: CupertinoSpacing.l),

                            // Warranty Expiry Date
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _warrantyExpiry == null
                                        ? 'Garansi Habis: Belum Dipilih'
                                        : 'Garansi Habis: ${DateFormat('dd-MM-yyyy').format(_warrantyExpiry!)}',
                                    style: context.subhead.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
                                  child: const Text('Pilih', style: TextStyle(color: Color(0xFF6E56CF))),
                                  onPressed: () => _showCupertinoDatePicker(
                                    initialDate: _warrantyExpiry ?? DateTime.now(),
                                    onDateSelected: (date) => setState(() => _warrantyExpiry = date),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: CupertinoSpacing.xl),

                      // 3. Deployment & Status Section
                      _buildSectionTitle('Penempatan & Status'),
                      CupertinoGlassContainer(
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Status Picker Field
                            _buildSelectField(
                              label: 'Status Aset',
                              value: _statuses.firstWhere((s) => s['value'] == _status)['label'] ?? 'Available',
                              onTap: _showStatusPicker,
                            ),
                            const SizedBox(height: CupertinoSpacing.l),

                            // Office Select Field
                            officesAsync.when(
                              data: (offices) => _buildSelectField(
                                label: 'Lokasi Kantor',
                                value: _selectedOffice != null ? _selectedOffice!.officeName : 'Belum Ditentukan',
                                onTap: () => _showOfficePicker(offices),
                              ),
                              loading: () => const Center(child: CupertinoActivityIndicator()),
                              error: (err, _) => Text('Gagal memuat kantor: $err', style: const TextStyle(color: CupertinoColors.destructiveRed)),
                            ),
                            const SizedBox(height: CupertinoSpacing.l),

                            // Employee Select Field
                            employeesAsync.when(
                              data: (employees) => _buildSelectField(
                                label: 'Diserahkan Kepada',
                                value: _selectedEmployee != null ? _selectedEmployee!.fullName : 'Belum Ditugaskan',
                                onTap: () => _showEmployeePicker(employees),
                              ),
                              loading: () => const Center(child: CupertinoActivityIndicator()),
                              error: (err, _) => Text('Gagal memuat karyawan: $err', style: const TextStyle(color: CupertinoColors.destructiveRed)),
                            ),
                            const SizedBox(height: CupertinoSpacing.l),

                            // Handover Date
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _assignedDate == null
                                        ? 'Tanggal Serah: Belum Dipilih'
                                        : 'Tanggal Serah: ${DateFormat('dd-MM-yyyy').format(_assignedDate!)}',
                                    style: context.subhead.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
                                  child: const Text('Pilih', style: TextStyle(color: Color(0xFF6E56CF))),
                                  onPressed: () => _showCupertinoDatePicker(
                                    initialDate: _assignedDate ?? DateTime.now(),
                                    onDateSelected: (date) => setState(() => _assignedDate = date),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: CupertinoSpacing.xl),

                      // 4. Detailed specs & notes Section
                      _buildSectionTitle('Spesifikasi & Catatan'),
                      CupertinoGlassContainer(
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Spesifikasi Teknis', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: CupertinoSpacing.s),
                            CupertinoTextField(
                              controller: _specificationsController,
                              placeholder: 'Misal: CPU 12-core, GPU 30-core, 36GB RAM, 1TB SSD',
                              maxLines: 4,
                            ),
                            const SizedBox(height: CupertinoSpacing.l),

                            Text('Catatan Internal', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: CupertinoSpacing.s),
                            CupertinoTextField(
                              controller: _notesController,
                              placeholder: 'Misal: Kondisi bekas, mulus, ada sedikit goresan di bodi belakang',
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: CupertinoSpacing.xl),

                      // 5. Photos / Attachments Section
                      _buildSectionTitle('Dokumentasi Foto Aset'),
                      CupertinoGlassContainer(
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_photoFile != null) ...[
                              Container(
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.file(File(_photoFile!.path), fit: BoxFit.cover),
                              ),
                              const SizedBox(height: CupertinoSpacing.m),
                            ] else if (asset.media.isNotEmpty) ...[
                              Container(
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  asset.media.first.originalUrl.startsWith('http')
                                      ? asset.media.first.originalUrl
                                      : '${AppConfig.baseUrl.replaceAll('/api/v1/', '')}${asset.media.first.originalUrl}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: CupertinoSpacing.m),
                            ],
                            SizedBox(
                              width: double.infinity,
                              child: CupertinoButton(
                                color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                                padding: EdgeInsets.zero,
                                onPressed: _showPhotoSourceSheet,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(CupertinoIcons.camera, color: Color(0xFF6E56CF), size: 20),
                                    const SizedBox(width: CupertinoSpacing.s),
                                    Text(
                                      _photoFile == null && asset.media.isEmpty ? 'Lampirkan Foto Aset' : 'Ganti Foto Terlampir',
                                      style: context.subhead.copyWith(color: const Color(0xFF6E56CF), fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: CupertinoSpacing.xxxl),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          onPressed: _isSubmitting ? null : _submit,
                          child: _isSubmitting
                              ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                              : const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: CupertinoSpacing.xxxl),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(middle: Text('Edit Aset Hardware')),
            child: Center(child: CupertinoActivityIndicator()),
          ),
          error: (err, _) => CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(middle: Text('Edit Aset Hardware')),
            child: Center(child: Text('Gagal memuat perusahaan: $err')),
          ),
        );
      },
      loading: () => const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Edit Aset Hardware')),
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (err, _) => CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Edit Aset Hardware')),
        child: Center(child: Text('Gagal memuat detail aset: $err')),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: CupertinoSpacing.s),
      child: Text(
        title,
        style: context.subhead.copyWith(
          fontWeight: FontWeight.bold,
          color: labelColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildSelectField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: CupertinoSpacing.s),
                  Text(
                    value,
                    style: context.subhead.copyWith(
                      fontWeight: FontWeight.w600,
                      color: value.startsWith('Pilih') || value.startsWith('Belum')
                          ? secondaryLabel
                          : labelColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_right, size: 16, color: secondaryLabel),
          ],
        ),
      ),
    );
  }
}
