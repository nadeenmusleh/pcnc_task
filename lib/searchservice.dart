import 'package:http/http.dart' as http;
import 'dart:convert';
import 'category.dart';
import 'product.dart';

class SearchService {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  // Fetch Categories based on the search query
  static Future<List<Category>> fetchCategories(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Category> allCategories =
          jsonResponse.map((category) => Category.fromJson(category)).toList();

      // Filter categories based on the search query
      if (query.isNotEmpty) {
        allCategories = allCategories
            .where((category) =>
                category.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      return allCategories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch Products based on the search query
  static Future<List<Product>> fetchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Product> allProducts =
          jsonResponse.map((product) => Product.fromJson(product)).toList();

      // Filter products based on the search query
      if (query.isNotEmpty) {
        allProducts = allProducts
            .where((product) =>
                product.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      return allProducts;
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch Combined Results for both Categories and Products based on the search query
  static Future<Map<String, List<Object>>> fetchCombinedResults(
      String query) async {
    final categories = await fetchCategories(query);
    final products = await fetchProducts(query);
    return {'categories': categories, 'products': products};
  }
}
