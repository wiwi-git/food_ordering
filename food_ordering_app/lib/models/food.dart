
class Food {
  final String name;
  final String imageUrl;
  final int price;
  final DateTime createdAt;
  final DateTime updatedAt;

  Food({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
