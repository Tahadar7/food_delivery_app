import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery_app/models/request_model.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/resources/firebase_helper.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/orderwidget.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/blocs/theme_provider.dart';

class MyOrderPage extends StatefulWidget {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  List<RequestModel>? requestList;
  AuthMethods authMethods = AuthMethods();
  FirebaseHelper mFirebaseHelper = FirebaseHelper();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      User? currentUser = await authMethods.getCurrentUser();

      if (currentUser != null) {
        mFirebaseHelper.fetchOrders(currentUser).then((
          List<RequestModel> list,
        ) {
          if (mounted) {
            setState(() {
              requestList = list;
            });
          }
        });
      } else {
        setState(() {
          requestList = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Provider.of<ThemeProvider>(context).isDarkMode
                  ? Colors.white
                  : Colors.black,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 18.0),
              child: Text(
                "My Orders",
                style: TextStyle(
                  color: UniversalVariables.orangeAccentColor,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: createListOfOrder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget createListOfOrder() {
    if (requestList == null) {
      return Container(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (requestList!.isEmpty) {
      return Container(
        height: 300,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[300]),
            SizedBox(height: 10),
            Text(
              "You haven't placed any orders yet.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: requestList!.length,
      itemBuilder: (_, index) {
        return OrderWidget(requestList![index]);
      },
    );
  }
}
