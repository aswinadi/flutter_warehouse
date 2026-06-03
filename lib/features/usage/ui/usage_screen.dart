import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/usage.dart';
import '../providers/usage_repository.dart';
import '../../inventory/models/inventory.dart';
import '../../inventory/providers/inventory_repository.dart';
import '../../inventory/providers/inventory_provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

class UsageScreen extends ConsumerStatefulWidget {
  const UsageScreen({super.key});

  @override
  ConsumerState<UsageScreen> createState() => _UsageScreenState();
}

class _UsageScreenState extends ConsumerState<UsageScreen> {
  Pond? _selectedPond;
  Inventory? _scannedItem;
  final _qtyController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pemakaian Tambak')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPondSelector(),
            const SizedBox(height: 24),
            if (_scannedItem == null)
              _buildScanButton()
            else
              _buildScannedItemCard(),
            const Spacer(),
            ElevatedButton(
              onPressed: (_selectedPond != null && _scannedItem != null) ? _submit : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('KIRIM PEMAKAIAN'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPondSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pilih Kolam / Tambak', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<Pond>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          value: _selectedPond,
          items: [
            // Mock items until API is verified
            const Pond(id: 1, name: 'Kolam A1'),
            const Pond(id: 2, name: 'Kolam A2'),
          ].map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
          onChanged: (val) => setState(() => _selectedPond = val),
        ),
      ],
    );
  }

  Widget _buildScanButton() {
    return OutlinedButton.icon(
      onPressed: _scanBarcode,
      icon: const Icon(Icons.qr_code_scanner),
      label: const Text('PINDAI BARCODE BARANG'),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 48)),
    );
  }

  Widget _buildScannedItemCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(_scannedItem!.productName ?? 'Item'),
              subtitle: Text('Stok: ${_scannedItem!.quantity} ${_scannedItem!.unit ?? ""}'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _scannedItem = null),
              ),
            ),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah yang Digunakan',
                suffixText: 'kg',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanBarcode() async {
    // Show scanner dialog or navigate to scanner
    // For now, mock a scan
    setState(() {
      _scannedItem = const Inventory(
        id: 1,
        sku: 'FEED-001',
        productName: 'Shrimp Feed Gold',
        quantity: 100,
        status: 'available',
        unit: 'kg'
      );
    });
  }

  Future<void> _submit() async {
    // Submit logic
  }
}
