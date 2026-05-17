import 'package:flutter/material.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/blocs/theme_provider.dart';
import 'add_food_page.dart';
import 'add_category_page.dart';
import 'admin_orders_page.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: UniversalVariables.orangeColor,
        iconTheme: const IconThemeData(color: Colors.white),
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
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
                        await AuthMethods().logout();
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "WELCOME, ADMIN!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/logo_new.png',
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              _buildAdminButton(
                context,
                "Add New Food Item",
                Icons.fastfood,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddFoodPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildAdminButton(
                context,
                "Add New Category",
                Icons.category,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddCategoryPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildAdminButton(
                context,
                "Manage Orders",
                Icons.receipt_long,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AdminOrdersPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: UniversalVariables.orangeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
