import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // العنوان الأساسي لواجهة API،
  static const String baseUrl = 'http://192.168.43.181:3000/api';

  // التحقق من الاتصال بالإنترنت
  static Future<bool> hasConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // جلب جميع المنتجات
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    if (!await hasConnection()) {
      throw Exception("لا يوجد اتصال بالإنترنت.");
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('فشل في تحميل المنتجات. كود الحالة: ${response.statusCode}');
      }
    } catch (e) {
      print("خطأ في جلب المنتجات: $e");
      throw Exception('حدث خطأ أثناء جلب المنتجات.'); // رفع استثناء موحد
    }
  }

  // جلب جميع المنتجات غير الممسوحة
  static Future<List<Map<String, dynamic>>> fetchUnscannedProducts() async {
    if (!await hasConnection()) {
      throw Exception("لا يوجد اتصال بالإنترنت.");
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/unscanned-products'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('فشل في تحميل المنتجات غير الممسوحة. كود الحالة: ${response.statusCode}');
      }
    } catch (e) {
      print("خطأ في جلب المنتجات غير الممسوحة: $e");
      throw Exception('حدث خطأ أثناء جلب المنتجات غير الممسوحة.'); // رفع استثناء موحد
    }
  }

  // إرسال بيانات منتج جديد إلى endpoint معين
  static Future<void> sendProductData(String name, String position, String qr, {required String endpoint}) async {
    if (!await hasConnection()) {
      throw Exception("لا يوجد اتصال بالإنترنت.");
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'position': position, 'qr': qr}),
      );

      if (response.statusCode == 409) {
        throw Exception('المنتج موجود بالفعل');
      } else if (response.statusCode != 201) {
        throw Exception('فشل في حفظ المنتج. كود الحالة: ${response.statusCode}');
      }
    } catch (e) {
      print("خطأ أثناء إرسال بيانات المنتج: $e");
      throw Exception('حدث خطأ أثناء إرسال بيانات المنتج.');
    }
  }

  // تحديث حالة المسح لمنتج معين
  static Future<void> updateProductScanStatus(String id, bool isScanned) async {
    if (!await hasConnection()) {
      throw Exception("لا يوجد اتصال بالإنترنت.");
    }

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'isScanned': isScanned}),
      );

      if (response.statusCode != 200) {
        throw Exception('فشل في تحديث حالة المسح. كود الحالة: ${response.statusCode} استجابة: ${response.body}');
      }
    } catch (e) {
      print("خطأ في تحديث حالة المسح: $e");
      throw Exception('حدث خطأ أثناء تحديث حالة المسح.');
    }
  }

  // حذف منتج بواسطة ID
  static Future<bool> deleteProduct(String id) async {
    if (!await hasConnection()) {
      throw Exception("لا يوجد اتصال بالإنترنت.");
    }

    try {
      final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('فشل في حذف المنتج. كود الحالة: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print("خطأ في حذف المنتج: $e");
      return false;
    }
  }


  // حذف منتج غير ممسوح بواسطة ID
  static Future<bool> delete_unscannedProduct(String id) async {
    if (!await hasConnection()) {
      throw Exception("لا يوجد اتصال بالإنترنت.");
    }

    try {
      final response = await http.delete(Uri.parse('$baseUrl/unscanned-products/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('فشل في حذف المنتج. كود الحالة: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print("خطأ في حذف المنتج: $e");
      return false;
    }
  }
  // إعادة تعيين حالة المسح لجميع المنتجات
  static Future<void> resetProductScanStatus() async {
    if (!await hasConnection()) {
      throw Exception("لا يوجد اتصال بالإنترنت.");
    }

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/products/reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'isScanned': false}),
      );

      if (response.statusCode != 200) {
        throw Exception('فشل في إعادة تعيين حالة المسح. كود الحالة: ${response.statusCode}');
      }
    } catch (e) {
      print("خطأ في إعادة تعيين حالة المسح: $e");
      throw Exception('حدث خطأ أثناء إعادة تعيين حالة المسح.'); // رفع استثناء موحد
    }
  }
}
