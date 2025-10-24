
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_result.dart';
import '../models/food.dart';
import '../models/order.dart';

class ApiService {
  final String baseUrl = "https://your-api-url.com"; // TODO: Replace with actual API URL

  Future<ApiResult<T>> _get<T>(String endpoint, T Function(dynamic json) fromJson) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      if (response.statusCode == 200) {
        return ApiResult(
          success: true,
          statusCode: response.statusCode,
          body: fromJson(jsonDecode(response.body)),
        );
      } else {
        return ApiResult(success: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return ApiResult(success: false, statusCode: -1);
    }
  }

  Future<ApiResult<T>> _post<T>(String endpoint, Map<String, dynamic> data, T Function(dynamic json) fromJson) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        return ApiResult(
          success: true,
          statusCode: response.statusCode,
          body: fromJson(jsonDecode(response.body)),
        );
      } else {
        return ApiResult(success: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return ApiResult(success: false, statusCode: -1);
    }
  }

  Future<ApiResult<Order>> createOrder(Order order) async {
    // This is a placeholder. In a real app, the server would create the order.
    return _post('orders', order.toJson(), (json) => order);
  }

  Future<ApiResult<List<Food>>> getFoodList() async {
    // Using a mock implementation for now
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Mock data
    List<Food> mockFoods = [
      Food(name: '라면', imageUrl: 'https://via.placeholder.com/150', price: 5000, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Food(name: '김밥', imageUrl: 'https://via.placeholder.com/150', price: 3000, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Food(name: '떡볶이', imageUrl: 'https://via.placeholder.com/150', price: 6000, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Food(name: '돈까스', imageUrl: 'https://via.placeholder.com/150', price: 8000, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Food(name: '우동', imageUrl: 'https://via.placeholder.com/150', price: 5500, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Food(name: '초밥', imageUrl: 'https://via.placeholder.com/150', price: 12000, createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ];

    return ApiResult(
      success: true,
      statusCode: 200,
      body: mockFoods,
    );
    
    // Real implementation would be:
    // return _get('foods', (json) => (json as List).map((item) => Food.fromJson(item)).toList());
  }

  Future<ApiResult<bool>> checkOrderStatus() async {
    // This is a placeholder for checking if ordering is currently possible.
    return _get('status', (json) => json['isOpen']);
  }
}
