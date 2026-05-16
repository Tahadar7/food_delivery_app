import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/resources/databaseSQL.dart';
import 'package:food_delivery_app/screens/CartPage.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';

class CartItems extends StatefulWidget {
  final FoodModel fooddata;
  CartItems(this.fooddata);

  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    int unitPrice = int.tryParse(widget.fooddata.price) ?? 0;
    int qty = int.tryParse(widget.fooddata.quantity ?? "1") ?? 1;
    int subTotal = unitPrice * qty;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: SizedBox(
          height: 70.0,
          width: 70.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              widget.fooddata.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.fastfood, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          widget.fooddata.name,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              "Quantity: $qty",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            Text(
              "Subtotal: ₹$subTotal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalVariables.orangeColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 26.0),
          onPressed: () => deleteFoodFromCart(widget.fooddata.keys),
        ),
      ),
    );
  }

  deleteFoodFromCart(String keys) async {
    DatabaseSql databaseSql = DatabaseSql();
    await databaseSql.openDatabaseSql();
    bool isDeleted = await databaseSql.deleteData(keys);

    if (!mounted) return;

    if (isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.fooddata.name} removed from cart'),
          duration: Duration(seconds: 1),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => CartPage()),
      );
    }
  }
}
