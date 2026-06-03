import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/asset.dart';
import '../providers/asset_repository.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/models/company.dart';
import '../../purchase_request/models/supplier.dart';

class AddAssetScreen extends ConsumerStatefulWidget {
  const AddAssetScreen({super.key});

  @override
  ConsumerState<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends ConsumerState<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil gambar: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isPurchaseDate) async {
    final initialDate = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6E56CF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPurchaseDate) {
          _purchaseDate = picked;
        } else {
          _warrantyExpiry = picked;
        }
      });
    }
  }

  Future<void> _selectAssignedDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6E56CF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _assignedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCompany == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih Perusahaan terlebih dahulu.')),
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih Kategori terlebih dahulu.')),
      );
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

      await ref.read(assetRepositoryProvider).createAsset(data, photoFile: _photoFile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aset hardware berhasil ditambahkan.'), backgroundColor: Colors.green),
        );
        ref.invalidate(assetListProvider); // Refresh list
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan aset: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final companiesAsync = ref.watch(companiesProvider);
    final officesAsync = _selectedCompany != null
        ? ref.watch(assetOfficesProvider(companyId: _selectedCompany!.id))
        : const AsyncValue<List<AssetOffice>>.data([]);
    final employeesAsync = _selectedCompany != null
        ? ref.watch(assetEmployeesProvider(companyId: _selectedCompany!.id))
        : const AsyncValue<List<AssetEmployee>>.data([]);
    final suppliersAsync = _selectedCompany != null
        ? ref.watch(assetSuppliersProvider(companyId: _selectedCompany!.id))
        : const AsyncValue<List<Supplier>>.data([]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text('Tambah Aset Hardware'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Identification Section
              _buildSectionTitle('Identifikasi Aset'),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Company Dropdown
                      companiesAsync.when(
                        data: (companies) => DropdownButtonFormField<Company>(
                          decoration: const InputDecoration(
                            labelText: 'Perusahaan *',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _selectedCompany,
                          items: companies.map((c) {
                            return DropdownMenuItem<Company>(
                              value: c,
                              child: Text(c.companyName),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedCompany = val;
                              _selectedOffice = null;
                              _selectedEmployee = null;
                              _selectedSupplier = null;
                            });
                          },
                          validator: (val) => val == null ? 'Perusahaan wajib dipilih' : null,
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Text('Gagal memuat perusahaan: $err'),
                      ),
                      const SizedBox(height: 16),
                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Kategori *',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _selectedCategory,
                        items: _categories.map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedCategory = val;
                          });
                        },
                        validator: (val) => val == null ? 'Kategori wajib dipilih' : null,
                      ),
                      const SizedBox(height: 16),
                      // Asset Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Aset *',
                          hintText: 'Misal: MacBook Pro M3 Max 16"',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Nama aset wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _brandController,
                              decoration: const InputDecoration(
                                labelText: 'Brand',
                                hintText: 'Apple',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _modelController,
                              decoration: const InputDecoration(
                                labelText: 'Model',
                                hintText: 'A2991',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Serial Number
                      TextFormField(
                        controller: _serialNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Serial Number (S/N)',
                          hintText: 'C02XG8...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Acquisition Section
              _buildSectionTitle('Pembelian & Garansi'),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Purchase Date
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _purchaseDate == null
                                  ? 'Tanggal Beli: Belum Dipilih'
                                  : 'Tanggal Beli: ${DateFormat('dd-MM-yyyy').format(_purchaseDate!)}',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.calendar_month, color: Color(0xFF6E56CF)),
                            label: const Text('Pilih', style: TextStyle(color: Color(0xFF6E56CF))),
                            onPressed: () => _selectDate(context, true),
                          ),
                        ],
                      ),
                      const Divider(),
                      // Purchase Price
                      TextFormField(
                        controller: _purchasePriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Harga Beli (IDR)',
                          prefixText: 'Rp ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Supplier Dropdown
                      suppliersAsync.when(
                        data: (suppliers) => DropdownButtonFormField<Supplier>(
                          decoration: const InputDecoration(
                            labelText: 'Supplier',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _selectedSupplier,
                          disabledHint: const Text('Pilih perusahaan terlebih dahulu'),
                          items: suppliers.map((s) {
                            return DropdownMenuItem<Supplier>(
                              value: s,
                              child: Text(s.name),
                            );
                          }).toList(),
                          onChanged: _selectedCompany == null
                              ? null
                              : (val) {
                                  setState(() {
                                    _selectedSupplier = val;
                                  });
                                },
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Text('Gagal memuat supplier: $err'),
                      ),
                      const Divider(height: 32),
                      // Warranty Expiry Date
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _warrantyExpiry == null
                                  ? 'Masa Garansi Habis: Belum Dipilih'
                                  : 'Masa Garansi: ${DateFormat('dd-MM-yyyy').format(_warrantyExpiry!)}',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.calendar_month, color: Color(0xFF6E56CF)),
                            label: const Text('Pilih', style: TextStyle(color: Color(0xFF6E56CF))),
                            onPressed: () => _selectDate(context, false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Status & Assignment Section
              _buildSectionTitle('Penempatan & Status'),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Status Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Status Aset *',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _status,
                        items: _statuses.map((st) {
                          return DropdownMenuItem<String>(
                            value: st['value'],
                            child: Text(st['label']!),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _status = val ?? 'available';
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Office Dropdown
                      officesAsync.when(
                        data: (offices) => DropdownButtonFormField<AssetOffice>(
                          decoration: const InputDecoration(
                            labelText: 'Lokasi Kantor',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _selectedOffice,
                          disabledHint: const Text('Pilih perusahaan terlebih dahulu'),
                          items: offices.map((o) {
                            return DropdownMenuItem<AssetOffice>(
                              value: o,
                              child: Text(o.officeName),
                            );
                          }).toList(),
                          onChanged: _selectedCompany == null
                              ? null
                              : (val) {
                                  setState(() {
                                    _selectedOffice = val;
                                  });
                                },
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Text('Gagal memuat kantor: $err'),
                      ),
                      const SizedBox(height: 16),
                      // Employee Dropdown
                      employeesAsync.when(
                        data: (employees) => DropdownButtonFormField<AssetEmployee>(
                          decoration: const InputDecoration(
                            labelText: 'Ditugaskan Kepada',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _selectedEmployee,
                          disabledHint: const Text('Pilih perusahaan terlebih dahulu'),
                          items: employees.map((e) {
                            return DropdownMenuItem<AssetEmployee>(
                              value: e,
                              child: Text(e.fullName),
                            );
                          }).toList(),
                          onChanged: _selectedCompany == null
                              ? null
                              : (val) {
                                  setState(() {
                                    _selectedEmployee = val;
                                    // Auto change status to assigned if user is assigned
                                    if (val != null) {
                                      _status = 'assigned';
                                    }
                                  });
                                },
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Text('Gagal memuat karyawan: $err'),
                      ),
                      const Divider(height: 32),
                      // Assigned Date
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _assignedDate == null
                                  ? 'Tanggal Penyerahan: Belum Dipilih'
                                  : 'Tanggal Penyerahan: ${DateFormat('dd-MM-yyyy').format(_assignedDate!)}',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.calendar_month, color: Color(0xFF6E56CF)),
                            label: const Text('Pilih', style: TextStyle(color: Color(0xFF6E56CF))),
                            onPressed: () => _selectAssignedDate(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Specifications & Notes
              _buildSectionTitle('Spesifikasi & Keterangan'),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Specifications
                      TextFormField(
                        controller: _specificationsController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Spesifikasi Teknis',
                          hintText: 'Misal: 16GB RAM, 512GB SSD, macOS Sequoia',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Notes
                      TextFormField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Catatan Tambahan',
                          hintText: 'Kondisi fisik mulus, segel utuh...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 5. Photo Upload Section
              _buildSectionTitle('Foto Kondisi Aset'),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (_photoFile != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_photoFile!.path),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Kamera'),
                            onPressed: () => _pickImage(ImageSource.camera),
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Galeri'),
                            onPressed: () => _pickImage(ImageSource.gallery),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6E56CF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SIMPAN ASET'),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }
}
