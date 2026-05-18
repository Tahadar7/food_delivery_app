import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/resources/databaseSQL.dart';
import 'package:food_delivery_app/resources/firebase_helper.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:food_delivery_app/utils/stripe_service.dart';
class CartPageBloc with ChangeNotifier {
  List<FoodModel> foodList = [];
  int totalPrice = 0;

  FirebaseHelper mFirebaseHelper = FirebaseHelper();
  DatabaseSql databaseSql = DatabaseSql();

  BuildContext? context;

  getDatabaseValue() async {
    await databaseSql.openDatabaseSql();
    List<FoodModel> list = await databaseSql.getData();
    

    foodList = list;

    totalPrice = 0;

    for (var food in foodList) {
      int foodItemPrice = int.parse(food.price);

      int quantity = int.parse(food.quantity ?? "1");

      totalPrice += (foodItemPrice * quantity);
    }

    notifyListeners();
  }

  orderPlaceToFirebase(String name, String address) async {
    if (foodList.isEmpty) return;

    if (context == null) return;

    bool paymentSuccess = await StripeService.makePayment(
      context!,
      totalPrice.toString(),
      "INR",
    );

    if (paymentSuccess) {
      mFirebaseHelper
          .addOrder(totalPrice.toString(), foodList, name, address)
          .then((isAdded) async {
            await databaseSql.deleteAllData();

            if (context != null) {
              ScaffoldMessenger.of(context!).showSnackBar(
                const SnackBar(
                  content: Text("Order Placed Successfully!"),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pushAndRemoveUntil(
                context!,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            }
          });
    }
  }
}
