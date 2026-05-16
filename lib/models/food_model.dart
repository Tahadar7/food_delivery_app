class FoodModel {
  final String description;
  final String discount;
  final String image;
  final String menuId;
  final String name;
  final String price;
  final String keys;

  final String? quantity;

  FoodModel({
    required this.description,
    required this.discount,
    required this.image,
    required this.menuId,
    required this.name,
    required this.price,
    required this.keys,
    this.quantity,
  });

  Map<String, dynamic> toMap(FoodModel food) {
    return {
      'description': food.description,
      'discount': food.discount,
      'image': food.image,
      'menuId': food.menuId,
      'name': food.name,
      'price': food.price,
      'keys': food.keys,
      'quantity': food.quantity,
    };
  }

  factory FoodModel.fromMap(Map<dynamic, dynamic> mapData) {
    return FoodModel(
      description: mapData['description']?.toString() ?? "",
      discount: mapData['discount']?.toString() ?? "0",
      image: mapData['image']?.toString() ?? "",
      menuId: mapData['menuId']?.toString() ?? "",
      name: mapData['name']?.toString() ?? "Unknown Food",
      price: mapData['price']?.toString() ?? "0",
      keys: mapData['keys']?.toString() ?? "",

      quantity: mapData['quantity']?.toString() ?? "1",
    );
  }
}
