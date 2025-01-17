class Product {
  final int id;
  final String name;
  final double price;
  bool isSelected;

  Product({required this.id, required this.name, required this.price, this.isSelected = false});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
}
