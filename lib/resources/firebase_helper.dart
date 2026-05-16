import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_delivery_app/models/category_model.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/request_model.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/resources/databaseSQL.dart';

class FirebaseHelper {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static final DatabaseReference _ordersReference = _database.ref().child(
    "Orders",
  );
  static final DatabaseReference _categoryReference = _database.ref().child(
    "Category",
  );
  static final DatabaseReference _foodReference = _database.ref().child(
    "Foods",
  );

  Future<List<FoodModel>> fetchAllFood() async {
    List<FoodModel> foodList = [];
    DatabaseEvent event = await _foodReference.once();

    if (event.snapshot.value != null) {
      for (var element in event.snapshot.children) {
        final Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(
          element.value as Map,
        );
        foodList.add(FoodModel.fromMap(map));
      }
    }
    return foodList;
  }

  Future<List<FoodModel>> fetchSpecifiedFoods(String queryStr) async {
    List<FoodModel> foodList = [];
    DatabaseEvent event = await _foodReference.once();

    for (var element in event.snapshot.children) {
      final Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(
        element.value as Map,
      );
      FoodModel food = FoodModel.fromMap(map);
      if (food.menuId == queryStr) {
        foodList.add(food);
      }
    }
    return foodList;
  }

  Future<List<CategoryModel>> fetchCategory() async {
    List<CategoryModel> categoryList = [];
    DatabaseEvent event = await _categoryReference.once();

    for (var element in event.snapshot.children) {
      if (element.value != null) {
        final Map<dynamic, dynamic> e = Map<dynamic, dynamic>.from(
          element.value as Map,
        );
        categoryList.add(
          CategoryModel(
            image: e['image'] ?? e['Image'] ?? "",
            name: e['name'] ?? e['Name'] ?? "",
            keys: e['keys'] ?? e['Keys'] ?? element.key ?? "",
          ),
        );
      }
    }
    return categoryList;
  }

  Future<void> addFood(FoodModel food) async {
    await _foodReference.child(food.keys).set(food.toMap(food));
  }

  Future<void> addCategory(CategoryModel category) async {
    await _categoryReference.child(category.keys).set(category.toMap());
  }

  Future<List<RequestModel>> fetchOrders(User currentUser) async {
    List<RequestModel> requestList = [];
    DatabaseReference userOrderRef = _ordersReference.child(currentUser.uid);

    DatabaseEvent event = await userOrderRef.once();

    if (event.snapshot.value != null) {
      for (var element in event.snapshot.children) {
        final Map<dynamic, dynamic> e = Map<dynamic, dynamic>.from(
          element.value as Map,
        );
        requestList.add(RequestModel.fromMap(e, orderKey: element.key));
      }
    }

    return requestList.reversed.toList();
  }

  Future<List<RequestModel>> fetchAllOrdersAdmin() async {
    List<RequestModel> allOrders = [];
    DatabaseEvent event = await _ordersReference.once();
    if (event.snapshot.value != null) {
      for (var userOrders in event.snapshot.children) {
        for (var order in userOrders.children) {
          final Map<dynamic, dynamic> e = Map<dynamic, dynamic>.from(
            order.value as Map,
          );
          allOrders.add(RequestModel.fromMap(e, orderKey: order.key));
        }
      }
    }
    return allOrders.reversed.toList();
  }

  Future<void> updateOrderStatus(
    String uid,
    String orderKey,
    String newStatus,
  ) async {
    await _ordersReference.child(uid).child(orderKey).update({
      "status": newStatus,
    });
  }

  Future<void> addOrder(
    String totalPrice,
    List<FoodModel> orderedFoodList,
    String name,
    String address,
  ) async {
    User? user = await AuthMethods().getCurrentUser();
    if (user == null) return;

    Map orderedFoodsMap = {};
    for (var food in orderedFoodList) {
      orderedFoodsMap[food.keys] = food.toMap(food);
    }

    RequestModel request = RequestModel(
      address: address,
      name: name,
      uid: user.uid,
      status: "0",
      total: totalPrice,
      foodList: orderedFoodsMap,
    );

    await _ordersReference
        .child(user.uid)
        .push()
        .set(request.toMap(request))
        .then((value) async {
          DatabaseSql databaseSql = DatabaseSql();
          await databaseSql.openDatabaseSql();
          await databaseSql.deleteAllData();
        });
  }
}
