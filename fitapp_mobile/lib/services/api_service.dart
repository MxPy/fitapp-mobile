import 'dart:convert';
import 'package:fitapp_mobile/models/product.dart';
import 'package:fitapp_mobile/models/user.dart';
import 'package:fitapp_mobile/models/user_day.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.33.15:8080/v1';
  
  // Headers
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Users endpoints
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<User> createUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: headers,
        body: json.encode(user.toJson()),
      );
      
      if (response.statusCode == 201) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<User> getUser(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$id'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Products endpoints
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Product> createProduct(Product product, String userId) async {
    try {
      var productJson = product.toJson();
      productJson['user_id'] = userId;
      
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: headers,
        body: json.encode(productJson),
      );
      
      if (response.statusCode == 201) {
        return product; // API zwraca 201 bez body
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // UserDay endpoints
  Future<UserDay?> getUserDay(String userId, String date) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-days/search?userId=$userId&date=$date'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        return UserDay.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null; // Brak danych na ten dzień
      } else {
        throw Exception('Failed to load user day: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<UserDay> createUserDay(UserDay userDay) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user-days'),
        headers: headers,
        body: json.encode(userDay.toJson()),
      );
      
      if (response.statusCode == 201) {
        return UserDay.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create user day: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> updateUserDay(String id, UserDay userDay) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user-days/$id'),
        headers: headers,
        body: json.encode(userDay.toJson()),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update user day: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}