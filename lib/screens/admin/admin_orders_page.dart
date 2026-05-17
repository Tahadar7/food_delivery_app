import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/request_model.dart';
import 'package:food_delivery_app/resources/firebase_helper.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/orderwidget.dart';

class AdminOrdersPage extends StatefulWidget {
  @override
  _AdminOrdersPageState createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  List<RequestModel>? requestList;
  FirebaseHelper mFirebaseHelper = FirebaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void _fetchOrders() {
    mFirebaseHelper.fetchAllOrdersAdmin().then((List<RequestModel> list) {
      if (mounted) {
        setState(() {
          requestList = list;
        });
      }
    });
  }

  void _updateStatus(RequestModel request, String newStatus) async {
    if (request.orderKey != null && request.uid != "") {
      await mFirebaseHelper.updateOrderStatus(
        request.uid,
        request.orderKey!,
        newStatus,
      );
      _fetchOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Orders", style: TextStyle(color: Colors.white)),
        backgroundColor: UniversalVariables.orangeColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: requestList == null
          ? Center(child: CircularProgressIndicator())
          : requestList!.isEmpty
          ? Center(
              child: Text(
                "No orders found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: requestList!.length,
              itemBuilder: (context, index) {
                RequestModel request = requestList![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      OrderWidget(request),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _statusButton(request, "0", "Placed", Colors.blue),
                            _statusButton(
                              request,
                              "1",
                              "On Way",
                              Colors.orange,
                            ),
                            _statusButton(
                              request,
                              "2",
                              "Shipped",
                              Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _statusButton(
    RequestModel request,
    String statusValue,
    String title,
    Color color,
  ) {
    bool isCurrent = request.status == statusValue;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isCurrent ? color : Colors.grey.shade300,
        foregroundColor: isCurrent ? Colors.white : Colors.black,
      ),
      onPressed: isCurrent ? null : () => _updateStatus(request, statusValue),
      child: Text(title),
    );
  }
}
