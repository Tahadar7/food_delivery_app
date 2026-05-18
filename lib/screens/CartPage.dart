import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery_app/blocs/CartPageBloc.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/cartitemswidget.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/blocs/theme_provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartPageBloc(),
      child: CartPageContent(),
    );
  }
}

class CartPageContent extends StatefulWidget {
  const CartPageContent() : super();

  @override
  _CartPageContentState createState() => _CartPageContentState();
}

class _CartPageContentState extends State<CartPageContent> {
  late CartPageBloc cartPageBloc;
  final TextEditingController nametextcontroller = TextEditingController();
  final TextEditingController addresstextcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await cartPageBloc.getDatabaseValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    cartPageBloc = Provider.of<CartPageBloc>(context);
    cartPageBloc.context = context;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Provider.of<ThemeProvider>(context).isDarkMode
              ? Colors.white
              : Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: cartPageBloc.foodList.isEmpty && cartPageBloc.totalPrice == 0
          ? _buildEmptyState()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Order",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                      ),
                    ),
                    Divider(thickness: 2.0),
                    createListCart(),
                    createTotalPriceWidget(),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Your cart is empty!",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget createTotalPriceWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total :", style: TextStyle(fontSize: 22.0)),
              Text(
                "Rs.${cartPageBloc.totalPrice}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: UniversalVariables.orangeColor,
                  fontSize: 28.0,
                ),
              ),
            ],
          ),
          Divider(thickness: 2.0),
          SizedBox(height: 20.0),
          SizedBox(
            height: 55,
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  UniversalVariables.orangeColor,
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              onPressed: () => _showDialog(),
              child: Text(
                "Place Order",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createListCart() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cartPageBloc.foodList.length,
      itemBuilder: (_, index) {
        return CartItems(cartPageBloc.foodList[index]);
      },
    );
  }

  _showDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delivery Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nametextcontroller,
                decoration: InputDecoration(
                  labelText: 'Recipient Name',
                  hintText: 'eg. Taha',
                ),
              ),
              TextField(
                controller: addresstextcontroller,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'eg. NTU Faisalabad',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: UniversalVariables.orangeColor,
              ),
              child: Text('Order Now', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (nametextcontroller.text.isNotEmpty &&
                    addresstextcontroller.text.isNotEmpty) {
                  cartPageBloc.orderPlaceToFirebase(
                    nametextcontroller.text,
                    addresstextcontroller.text,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nametextcontroller.dispose();
    addresstextcontroller.dispose();
    super.dispose();
  }
}
