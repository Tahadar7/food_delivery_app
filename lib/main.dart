import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_delivery_app/models/user_model.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/screens/admin/admin_home_page.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:food_delivery_app/screens/loginpages/login.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/blocs/theme_provider.dart';
import 'package:food_delivery_app/utils/stripe_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize Stripe
  Stripe.publishableKey = StripeService.publishableKey;
  await Stripe.instance.applySettings();

  runApp(
    ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Food App',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: MaterialColor(
          UniversalVariables.orangeColor.toARGB32(),
          <int, Color>{
            50: UniversalVariables.orangeColor,
            100: UniversalVariables.orangeColor,
            200: UniversalVariables.orangeColor,
            300: UniversalVariables.orangeColor,
            400: UniversalVariables.orangeColor,
            500: UniversalVariables.orangeColor,
            600: UniversalVariables.orangeColor,
            700: UniversalVariables.orangeColor,
            800: UniversalVariables.orangeColor,
            900: UniversalVariables.orangeColor,
          },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(backgroundColor: Colors.orange),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: _authMethods.onAuthStateChanged,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return FutureBuilder<UserModel>(
              future: _authMethods.getUserDetails(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (userSnapshot.hasError || !userSnapshot.hasData) {
                  return HomePage();
                }
                if (userSnapshot.data?.isAdmin == true) {
                  return AdminHomePage();
                } else {
                  return HomePage();
                }
              },
            );
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}