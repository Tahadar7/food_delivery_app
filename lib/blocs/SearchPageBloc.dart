import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/resources/firebase_helper.dart';

class SearchPageBloc with ChangeNotifier {
  final FirebaseHelper _firebaseHelper = FirebaseHelper();

  List<FoodModel> _fullFoodList = [];

  List<FoodModel> get fullFoodList => _fullFoodList;

  String _query = "";
  String get query => _query;

  Future<void> loadFoodList() async {
    try {
      final List<FoodModel> foods = await _firebaseHelper.fetchAllFood();
      _fullFoodList = foods;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading food list for search: $e");
    }
  }

  List<FoodModel> searchFoodsFromList(String searchTerm) {
    if (searchTerm.isEmpty) {
      return _fullFoodList;
    }

    final String cleanQuery = searchTerm.toLowerCase().trim();

    return _fullFoodList.where((food) {
      final String foodName = food.name.toLowerCase();
      return foodName.contains(cleanQuery);
    }).toList();
  }

  void setQuery(String q) {
    _query = q;
    notifyListeners();
  }
}
