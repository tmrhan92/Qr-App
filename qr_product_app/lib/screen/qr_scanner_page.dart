import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';
import '../api_service.dart';

class QRScannerPage extends StatefulWidget {
  final Function(String) onProductScanned;
  final Function(String) onProductDeleted;

  QRScannerPage({required this.onProductScanned, required this.onProductDeleted});

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
      final productData = jsonDecode(data); // فك تشفير البيانات
      String productName = productData['productName']; // الحصول على اسم المنتج
      String productPosition = productData['productPosition']; // الحصول على موقع المنتج

      // البحث عن المنتج في قاعدة البيانات باستخدام productName و productPosition
      final productResponse = await ApiService.fetchProductByNameAndPosition(productName, productPosition);

      if (productResponse.isEmpty) {
        throw Exception("المنتج غير موجود");
      }

      String productId = productResponse[0]['_id']; // استرداد _id الخاص بالمنتج

      print("Sending Product ID: $productId"); // طباعة المعرف قبل الإرسال

      setState(() {
        isSending = true; // تغيير حالة الواجهة
      });

      // استدعاء API لتحديث حالة المنتج
      final response = await ApiService.updateProductScanStatus(productId, true);

      // طباعة حالة الاستجابة
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // التحقق من استجابة الـ API
      if (response.statusCode == 200) {
        widget.onProductScanned(productId); // استدعاء الدالة عند المسح الناجح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم مسح المنتج وتحديث الحالة بنجاح!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في تحديث حالة المنتج. رمز الخطأ: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ أثناء معالجة رمز QR: $e")),
      );
    } finally {
      setState(() {
        isSending = false; // إعادة تعيين حالة الإرسال
      });
    }
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
