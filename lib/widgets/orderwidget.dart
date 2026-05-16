import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/models/request_model.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'foodTitleWidget.dart';

class OrderWidget extends StatefulWidget {
  final RequestModel request;
  OrderWidget(this.request);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                widget.request.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(widget.request.address),
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage("assets/cdn_icons.png"),
              ),
              trailing: Text(
                "₹${widget.request.total}",
                style: TextStyle(
                  color: UniversalVariables.orangeColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            createStatusBar(),
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: Text(
                "Items Ordered:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                ),
              ),
            ),
            createListOfFood(),
          ],
        ),
      ),
    );
  }

  Widget createStatusBar() {
    int currentStatus = int.tryParse(widget.request.status) ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusIcon("Placed", currentStatus >= 0),
          _buildStatusLine(currentStatus >= 1),
          _buildStatusIcon("On Way", currentStatus >= 1),
          _buildStatusLine(currentStatus >= 2),
          _buildStatusIcon("Shipped", currentStatus >= 2),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String title, bool isActive) {
    return Column(
      children: [
        Icon(
          isActive ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isActive ? UniversalVariables.orangeColor : Colors.grey,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: isActive ? UniversalVariables.orangeColor : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? UniversalVariables.orangeColor : Colors.grey.shade300,
      ),
    );
  }

  Widget createListOfFood() {
    List<FoodModel> foodList = widget.request.orderedItems;

    return Container(
      height: 160.0,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: foodList.length,
        itemBuilder: (_, index) {
          final food = foodList[index];
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              children: [
                FoodTitleWidget(food),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: UniversalVariables.orangeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Qty: ${food.quantity}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
