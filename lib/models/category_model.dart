class CategoryModel {
  final String image;
  final String name;
  final String keys;

  CategoryModel({required this.image, required this.name, required this.keys});

  factory CategoryModel.fromMap(Map<dynamic, dynamic> map, String key) {
    return CategoryModel(
      image: map['image'] ?? map['Image'] ?? "",
      name: map['name'] ?? map['Name'] ?? "Category",

      keys: map['keys'] ?? map['Keys'] ?? key,
    );
  }

  Map<String, dynamic> toMap() {
    return {'image': image, 'name': name, 'keys': keys};
  }
}
