import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/product.dart';

class ApiService {
  final String baseUrl = 'http://mobilecomputing.my.id/api_dhio';

  Future<User?> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'success') {
        return User.fromJson(json['data']);
      }
    }
    return null;
  }

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'success') {
        return User.fromJson(json['data']);
      }
    }
    return null;
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/get_products.php'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'success') {
        final products = (json['data'] as List)
            .map((item) => Product.fromJson(item))
            .toList();
        return products;
      }
    }
    return [];
  }

  Future<bool> createOrder(int userId, List<int> productIds) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_order.php'),
      body: {
        'user_id': userId.toString(),
        'product_ids': productIds.join(','),
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['status'] == 'success';
    }
    return false;
  }
}
