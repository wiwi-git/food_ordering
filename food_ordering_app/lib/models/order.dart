
import 'dart:core';
import 'food.dart';

class Order {
  final String id;
  final List<Food> orderedFoods;
  final int totalPrice;
  final DateTime? calculatedAt;
  final DateTime currentTime;

  Order({
    required this.id,
    required this.orderedFoods,
    required this.totalPrice,
    this.calculatedAt,
    required this.currentTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderedFoods': orderedFoods.map((food) => food.name).toList(),
      'totalPrice': totalPrice,
      'calculatedAt': calculatedAt?.toIso8601String(),
      'currentTime': currentTime.toIso8601String(),
    };
  }
}
