import 'dart:io';
import 'package:flutter/services.dart';
// Note: We'll use raw sockets for network printing (ESC/POS and ZPL)

class PrinterService {
  Future<void> printToNetwork(String ip, int port, List<int> bytes) async {
    try {
      final socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 5));
      socket.add(bytes);
      await socket.flush();
      await socket.close();
    } catch (e) {
      throw Exception('Failed to connect to printer at $ip:$port: $e');
    }
  }

  /// Prints a ZPL label to a Zebra printer via Network
  Future<void> printZebraLabel(String ip, String sku, String qrCode, String name) async {
    // Basic ZPL II template
    final String zpl = """
^XA
^FO50,50^A0N,40,40^FD$name^FS
^FO50,100^A0N,30,30^FDSKU: $sku^FS
^FO100,150^BQN,2,6^FDQA,$qrCode^FS
^XZ
""";
    await printToNetwork(ip, 9100, utf8.encode(zpl));
  }

  /// Prints to a generic ESC/POS printer via Network
  Future<void> printGenericEscPos(String ip, String text) async {
    // Simplified ESC/POS initialization
    final List<int> bytes = [
      0x1B, 0x40, // Initialize
      ...utf8.encode(text),
      0x0A, 0x0A, 0x0A, // Feed
      0x1D, 0x56, 0x41, 0x03, // Cut
    ];
    await printToNetwork(ip, 9100, bytes);
  }
}

// Minimal UTF8 shim if dart:convert is not imported
final utf8 = const Utf8Codec();
class Utf8Codec {
  const Utf8Codec();
  List<int> encode(String input) => input.codeUnits;
}
