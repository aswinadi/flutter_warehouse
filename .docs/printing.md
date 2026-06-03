# Printing Documentation

## Overview
The app supports network-based printing (Wi-Fi/Ethernet) for high-speed warehouse operations.

## Supported Protocols
1. **ZPL II (Zebra Programming Language)**:
   - Used for thermal label printers (e.g., Zebra ZT series, GX series).
   - Generates QR codes and SKU labels natively on the printer hardware.
   - Default Port: `9100`.

2. **ESC/POS (Generic)**:
   - Used for standard receipt printers (e.g., Epson, Bixolon).
   - Supports text-based printing and hardware cutting.
   - Default Port: `9100`.

## Printer Service Implementation
The `PrinterService` in `core/services/printer_service.dart` uses raw `dart:io` Sockets. This avoids overhead and ensures compatibility with standard network print servers.

### Example Usage:
```dart
final printer = PrinterService();
await printer.printZebraLabel(
  '192.168.1.100', 
  'SKU-123', 
  'https://qr.maxmar.com/123', 
  'Product Name'
);
```

## Troubleshooting
- Ensure the printer is on the same subnet as the mobile device/computer.
- Port 9100 must be open on the printer's network configuration.
- For Zebra, ensures the media type (Gap vs Continuous) matches the label stock.
