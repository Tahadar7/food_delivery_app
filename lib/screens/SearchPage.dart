import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery_app/blocs/SearchPageBloc.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/blocs/theme_provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchPageBloc(),
      child: SearchPageContent(),
    );
  }
}

class SearchPageContent extends StatefulWidget {
  @override
  _SearchPageContentState createState() => _SearchPageContentState();
}

class _SearchPageContentState extends State<SearchPageContent> {
  final TextEditingController searchCtrl = TextEditingController();
  late SearchPageBloc searchPageBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      searchPageBloc.loadFoodList();
    });
  }

  @override
  Widget build(BuildContext context) {
    searchPageBloc = Provider.of<SearchPageBloc>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Provider.of<ThemeProvider>(context).isDarkMode
              ? Colors.white
              : Colors.black,
        ),
        title: Text(
          "Search Dishes",
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          createSearchBar(),
          Expanded(child: buildSuggestions(searchPageBloc.query)),
        ],
      ),
    );
  }

  Widget buildSuggestions(String query) {
    final List<FoodModel> suggestionList = searchPageBloc.searchFoodsFromList(
      query,
    );

    if (searchPageBloc.fullFoodList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (suggestionList.isEmpty && query.isNotEmpty) {
      return Center(child: Text("No dishes found matching '$query'"));
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemCount: suggestionList.length,
      itemBuilder: (_, index) {
        return FoodTitleWidget(suggestionList[index]);
      },
    );
  }

  Widget createSearchBar() {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.search, color: UniversalVariables.orangeColor),
          Expanded(
            child: TextField(
              onChanged: (val) => searchPageBloc.setQuery(val),
              controller: searchCtrl,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                hintText: "Search for pizza, burgers...",
              ),
            ),
          ),
          if (searchCtrl.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                searchCtrl.clear();
                searchPageBloc.setQuery("");
              },
            ),
        ],
      ),
    );
  }
}
