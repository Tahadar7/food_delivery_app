import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/category_model.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/resources/firebase_helper.dart';

class HomePageBloc with ChangeNotifier {
  FirebaseHelper mFirebaseHelper = FirebaseHelper();
  AuthMethods mAuthMethods = AuthMethods();

  List<CategoryModel> categoryList = [];
  List<FoodModel> foodList = [];
  List<FoodModel> popularFoodList = [];
  List<FoodModel> bannerFoodList = [];

  bool isCategoryLoading = true;
  bool isFoodLoading = true;

  User? mFirebaseUser;

  getCurrentUser() {
    mAuthMethods.getCurrentUser().then((User? currentUser) {
      mFirebaseUser = currentUser;
      notifyListeners();
    });
  }

  getCategoryFoodList() {
    isCategoryLoading = true;
    mFirebaseHelper.fetchCategory().then((List<CategoryModel> cList) {
      categoryList = cList;
      isCategoryLoading = false;
      notifyListeners();
    });
  }

  getRecommendedFoodList() {
    isFoodLoading = true;
    mFirebaseHelper.fetchAllFood().then((List<FoodModel> fList) {
      popularFoodList.clear();
      foodList.clear();
      bannerFoodList.clear();

      foodList.addAll(fList);

      if (fList.isNotEmpty) {
        bannerFoodList.addAll(fList.take(3).toList());

        if (fList.length > 3) {
          popularFoodList.addAll(fList.skip(3).take(5).toList());
        } else {
          popularFoodList.addAll(fList);
        }
      }

      isFoodLoading = false;
      notifyListeners();
    });
  }
}
