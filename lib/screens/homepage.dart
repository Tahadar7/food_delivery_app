import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery_app/blocs/HomePageBloc.dart';
import 'package:food_delivery_app/models/category_model.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/screens/CartPage.dart';
import 'package:food_delivery_app/screens/CategoryListPage.dart';
import 'package:food_delivery_app/screens/FoodDetailPage.dart';
import 'package:food_delivery_app/screens/MyOrderPage.dart';
import 'package:food_delivery_app/screens/SearchPage.dart';
import 'package:food_delivery_app/widgets/categorywidget.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/blocs/theme_provider.dart';
import 'VideoSearch.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageBloc(),
      child: HomePageContent(),
    );
  }
}

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  late HomePageBloc homePageBloc;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      homePageBloc.getCurrentUser();
      homePageBloc.getCategoryFoodList();
      homePageBloc.getRecommendedFoodList();
    });
  }

  @override
  Widget build(BuildContext context) {
    homePageBloc = Provider.of<HomePageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0.0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
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
      drawer: createDrawer(),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              createSearchBar(),
              SizedBox(height: 10.0),
              createbanner(),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  "Food Category",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              createFoodCategory(),
              createPopularFoodList(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  "For You",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              createForYou(),
            ],
          ),
        ),
      ),
    );
  }

  createbanner() {
    final List<Widget> imageSliders = homePageBloc.bannerFoodList
        .map(
          (item) => GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodDetailPage(food: item),
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item.image, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        child: Text(
                          '${item.name}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        child: Column(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ),
              items: imageSliders,
            ),
          ],
        ),
      ),
    );
  }

  createDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              accountName: Text(""),
              accountEmail: Text(
                homePageBloc.mFirebaseUser?.email ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/breakfast.webp"),
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.orange,
            ),
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.home, color: Colors.orangeAccent),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.shopping_basket, color: Colors.orangeAccent),
            title: Text('Cart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.fastfood, color: Colors.orangeAccent),
            title: Text('My Order'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyOrderPage()),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.youtube_searched_for),
            leading: Icon(Icons.video_call_sharp, color: Colors.orangeAccent),
            title: Text('Food Video search'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoSearchPage()),
              );
            },
          ),
          ListTile(
            trailing: Switch(
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme();
              },
              activeColor: Colors.orange,
            ),
            leading: Icon(Icons.brightness_6, color: Colors.orangeAccent),
            title: Text('Dark Theme'),
          ),
          ListTile(
            trailing: const Icon(Icons.exit_to_app, color: Colors.red),
            leading: const Icon(Icons.clear, color: Colors.orangeAccent),
            title: const Text('Logout'),
            onTap: () {
              _confirmLogout(context);
            },
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final AuthMethods _authMethods = AuthMethods();
              await _authMethods.logout();
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  createPopularFoodList() {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              "Popular Food ",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 200.0,
            child: homePageBloc.isFoodLoading
                ? const Center(child: CircularProgressIndicator())
                : homePageBloc.popularFoodList.isEmpty
                ? const Center(
                    child: Text(
                      "No popular food added yet.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homePageBloc.popularFoodList.length,
                    itemBuilder: (_, index) {
                      return FoodTitleWidget(
                        homePageBloc.popularFoodList[index],
                        heroTagPrefix: "popular_",
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  createSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.orange),
              SizedBox(width: 10),
              Text(
                "Search food items...",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  gotoCateogry(CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryListPage(category)),
    );
  }

  createFoodCategory() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 300.0,
      child: homePageBloc.isCategoryLoading
          ? const Center(child: CircularProgressIndicator())
          : homePageBloc.categoryList.isEmpty
          ? const Center(
              child: Text(
                "No categories added yet.",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: homePageBloc.categoryList.length,
              itemBuilder: (_, index) {
                return CategoryWidget(homePageBloc.categoryList[index]);
              },
            ),
    );
  }

  createForYou() {
    return homePageBloc.isFoodLoading
        ? const Center(child: CircularProgressIndicator())
        : homePageBloc.foodList.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "No items available.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homePageBloc.foodList.length,
            itemBuilder: (_, index) {
              return FoodTitleWidget(
                homePageBloc.foodList[index],
                heroTagPrefix: "foryou_",
              );
            },
          );
  }
}
