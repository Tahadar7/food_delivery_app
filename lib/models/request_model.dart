import 'package:food_delivery_app/models/food_model.dart';

class RequestModel {
  final String address;
  final Map foodList;
  final String name;
  final String uid;
  final String status;
  final String total;
  String? orderKey;

  RequestModel({
    required this.address,
    required this.foodList,
    required this.name,
    required this.uid,
    required this.status,
    required this.total,
    this.orderKey,
  });

  List<FoodModel> get orderedItems {
    List<FoodModel> items = [];
    foodList.forEach((key, value) {
      items.add(FoodModel.fromMap(value));
    });
    return items;
  }

  Map<String, dynamic> toMap(RequestModel request) {
    return {
      'address': request.address,
      'foodList': request.foodList,
      'name': request.name,
      'uid': request.uid,
      'status': request.status,
      'total': request.total,
    };
  }

  factory RequestModel.fromMap(
    Map<dynamic, dynamic> mapData, {
    String? orderKey,
  }) {
    return RequestModel(
      address: mapData['address']?.toString() ?? "",
      foodList: mapData['foodList'] ?? {},
      name: mapData['name']?.toString() ?? "",
      uid: mapData['uid']?.toString() ?? "",
      status: mapData['status']?.toString() ?? "0",
      total: mapData['total']?.toString() ?? "0",
      orderKey: orderKey,
    );
  }
}
