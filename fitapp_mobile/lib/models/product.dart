class Product {
  final String id;
  final String productName;
  final int grams;
  final int kcal;
  final int proteins;
  final int carbs;
  final int fats;

  Product({
    required this.id,
    required this.productName,
    required this.grams,
    required this.kcal,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['product_name'],
      grams: 100,
      kcal: json['kcal'],
      proteins: json['proteins'],
      carbs: json['carbs'],
      fats: json['fats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'grams': grams,
      'kcal': kcal,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
      'user_id': '', // będzie ustawiane przez service
    };
  }
}
