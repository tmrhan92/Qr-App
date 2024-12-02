import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';
import '../api_service.dart';

class QRScannerPage extends StatefulWidget {
  final Function(String) onProductScanned; // Callback للإبلاغ عندما يتم مسح المنتج
  final Function(String) onProductDeleted; // Callback لحذف المنتج الممسوح

  QRScannerPage({required this.onProductScanned, required this.onProductDeleted}); // إضافة وحدة الحذف

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedData;
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            child: scannedData == null
                ? const Center(child: Text('Scan a code'))
                : ElevatedButton(
              onPressed: isSending ? null : () => processScannedData(scannedData),
              child: isSending
                  ? const CircularProgressIndicator()
                  : const Text('Send Data'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        if (scanData.code != null && scanData.code!.isNotEmpty) {
          scannedData = scanData.code!;
          print("Scanned Data: $scannedData");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid QR Code")),
          );
        }
      });
    });
  }

  void processScannedData(String? data) async {
    if (data == null || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لا توجد بيانات مسح ضوئي للتعامل معها")),
      );
      return;
    }

    try {
      final productData = jsonDecode(data);
      print("Parsed Product Data: $productData"); // طباعة البيانات المستخرجة
      if (productData is! Map<String, dynamic>) {
        throw Exception("تنسيق QR Code غير صالح");
      }

      setState(() {
        isSending = true;
      });

      String? productId = productData['_id']; // تأكد من أن هذا المفتاح موجود

      if (productId == null) {
        throw Exception("Product ID is null");
      }

      await ApiService.updateProductScanStatus(productId, true);
      widget.onProductScanned(productId); // Notify the PositionPage

      // Delete the product from UnscannedProductsPage
      widget.onProductDeleted(productId); // Notify to delete the product from unscanned products

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم مسح المنتج وتحديث الحالة بنجاح!")),
      );

      // Close the QR scanner page
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ أثناء معالجة رمز QR: $e")),
      );
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
