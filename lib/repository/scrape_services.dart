// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:model_testing/models/product.dart';

// class ApiService {
//   static const String baseUrl = "http://10.0.21.239:5000"; 
//   // ⚠️ Replace with your deployed Vercel URL when live

//   static Future<List<Product>> fetchProducts(String query) async {
//     final response = await http.get(
//       Uri.parse("$baseUrl/products?q=$query"),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List productsJson = data["results"];
//       return productsJson.map((e) => Product.fromJson(e)).toList();
//     } else {
//       throw Exception("Failed to load products");
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:model_testing/models/product.dart';

class ApiService {
  static Future<String> _getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('base_url');

    if (url == null || url.isEmpty) {
      throw Exception("Base URL not set");
    }
    return url;
  }

  static Future<List<Product>> fetchProducts(String query) async {
    final baseUrl = await _getBaseUrl();

    final response = await http.get(
      Uri.parse("$baseUrl/products?q=$query"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List productsJson = data["results"];
      return productsJson.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
