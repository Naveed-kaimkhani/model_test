import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:model_testing/models/product.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000"; 
  // ⚠️ Replace with your deployed Vercel URL when live

  static Future<List<Product>> fetchProducts(String query) async {
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
