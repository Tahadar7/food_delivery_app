import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery_app/blocs/FoodDetailPageBloc.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';
import 'package:provider/provider.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodModel food;
  FoodDetailPage({required this.food});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FoodDetailPageBloc(),
      child: FoodDetailPageContent(food),
    );
  }
}

class FoodDetailPageContent extends StatefulWidget {
  final FoodModel fooddata;
  FoodDetailPageContent(this.fooddata);
  @override
  _FoodDetailPageContentState createState() => _FoodDetailPageContentState();
}

class _FoodDetailPageContentState extends State<FoodDetailPageContent> {
  late FoodDetailPageBloc foodDetailPageBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      foodDetailPageBloc.getPopularFoodList();
      foodDetailPageBloc.generateRandomRating();
    });
  }

  @override
  Widget build(BuildContext context) {
    foodDetailPageBloc = Provider.of<FoodDetailPageBloc>(context);
    foodDetailPageBloc.context = context;

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: UniversalVariables.whiteColor),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: "avatar_${widget.fooddata.keys}",
              child: Container(
                alignment: Alignment.bottomLeft,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(80.0),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.fooddata.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(80.0),
                    ),
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      "${foodDetailPageBloc.rating} ★",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: UniversalVariables.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            createdetails(),
            createPopularFoodList(),
          ],
        ),
      ),
    );
  }

  createdetails() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.fooddata.name,
              style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.bold,
                color: UniversalVariables.orangeColor,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rs.${widget.fooddata.price}",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: UniversalVariables.orangeColor,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: UniversalVariables.orangeColor,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: () => foodDetailPageBloc.decreamentItems(),
                    ),
                    Text(
                      foodDetailPageBloc.mItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => foodDetailPageBloc.increamentItems(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Text(
            widget.fooddata.description.isNotEmpty
                ? widget.fooddata.description
                : "No description available for this delicious item.",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
          const SizedBox(height: 30.0),
          RatingBar(
            initialRating: double.tryParse(foodDetailPageBloc.rating) ?? 4.0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            onRatingUpdate: (r) {},
            ratingWidget: RatingWidget(
              full: Icon(Icons.star, color: UniversalVariables.amberColor),
              half: Icon(Icons.star_half, color: UniversalVariables.amberColor),
              empty: Icon(
                Icons.star_border,
                color: UniversalVariables.amberColor,
              ),
            ),
          ),
          const SizedBox(height: 30.0),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 55,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  UniversalVariables.orangeColor,
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              onPressed: () => foodDetailPageBloc.addToCart(widget.fooddata),
              child: const Text(
                "Add To Cart",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  createPopularFoodList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 10.0),
          child: Text(
            "Popular Food",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          height: 200.0,
          child: foodDetailPageBloc.isFoodLoading
              ? const Center(child: CircularProgressIndicator())
              : foodDetailPageBloc.foodList.isEmpty
              ? const Center(
                  child: Text(
                    "No popular food added yet.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 10),
                  itemCount: foodDetailPageBloc.foodList.length,
                  itemBuilder: (_, index) {
                    return FoodTitleWidget(foodDetailPageBloc.foodList[index]);
                  },
                ),
        ),
      ],
    );
  }
}
