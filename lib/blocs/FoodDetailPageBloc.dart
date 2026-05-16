import 'dart:math';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/resources/databaseSQL.dart';
import 'package:food_delivery_app/resources/firebase_helper.dart';

class FoodDetailPageBloc with ChangeNotifier {
  AuthMethods mAuthMethods = AuthMethods();
  FirebaseHelper mFirebaseHelper = FirebaseHelper();
  DatabaseSql databaseSql = DatabaseSql();

  List<FoodModel> foodList = [];
  var random = Random();
  String rating = "4.0";
  int mItemCount = 1;
  BuildContext? context;
  bool isFoodLoading = true;

  addToCart(FoodModel food) async {
    try {
      await databaseSql.openDatabaseSql();

      await databaseSql.insertData(food, mItemCount);

      final snackBar = SnackBar(
        content: Text('${food.name} (x$mItemCount) added to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      );

      mItemCount = 1;

      if (context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(snackBar);
      }

      notifyListeners();
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  getPopularFoodList() {
    isFoodLoading = true;
    notifyListeners();
    mFirebaseHelper.fetchAllFood().then((List<FoodModel> fList) {
      foodList.clear();
      if (fList.isNotEmpty) {
        fList.shuffle();
        foodList.addAll(fList.take(5).toList());
      }
      isFoodLoading = false;
      notifyListeners();
    });
  }

  void increamentItems() {
    mItemCount++;
    notifyListeners();
  }

  void decreamentItems() {
    if (mItemCount > 1) {
      mItemCount--;
      notifyListeners();
    }
  }

  void generateRandomRating() {
    rating = doubleInRange(random, 3.5, 5.0).toStringAsFixed(1);
    notifyListeners();
  }

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
}
