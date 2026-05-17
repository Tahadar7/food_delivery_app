import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/blocs/LoginPageBloc.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:food_delivery_app/screens/loginpages/register.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/screens/admin/admin_home_page.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/blocs/theme_provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginPageBloc(),
      child: LoginPageContent(),
    );
  }
}

class LoginPageContent extends StatefulWidget {
  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  TextEditingController textNameController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _hasSubmitted = false;

  late LoginPageBloc loginPageBloc;

  @override
  Widget build(BuildContext context) {
    loginPageBloc = Provider.of<LoginPageBloc>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Provider.of<ThemeProvider>(context).isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: UniversalVariables.orangeColor,
                  ),
                  onPressed: () {
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).toggleTheme();
                  },
                ),
              ),
              Form(
                key: _formKey,
                autovalidateMode: _hasSubmitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: buildForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildForm() {
    return Column(
      children: [
        SizedBox(height: 20.0),
        Hero(
          tag: 'hero',
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 100.0,
            child: ClipOval(child: Image.asset('assets/logo.png')),
          ),
        ),
        SizedBox(height: 20.0),
        TextFormField(
          validator: (email) {
            return loginPageBloc.validateEmail(email ?? '');
          },
          controller: textNameController,
          decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(Icons.email),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          validator: (password) {
            return loginPageBloc.validatePassword(password ?? '');
          },
          controller: textPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: Icon(Icons.password_outlined),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              _showForgotPasswordDialog(context);
            },
            child: Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        SizedBox(
          width: double.infinity,
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
            onPressed: loginPageBloc.isLoginPressed
                ? null
                : () async {
                    setState(() {
                      _hasSubmitted = true;
                    });
                    String? error = await loginPageBloc.validateFormAndLogin(
                      _formKey,
                      textNameController.text,
                      textPasswordController.text,
                    );
                    if (!mounted) return;
                    if (error == "ADMIN_LOGIN_SUCCESS") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminHomePage(),
                        ),
                      );
                    } else if (error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                    } else if (FirebaseAuth.instance.currentUser != null) {
                      gotoHomePage();
                    }
                  },
            child: Text(
              "Login",
              style: TextStyle(
                color: UniversalVariables.whiteColor,
                fontSize: 24,
              ),
            ),
          ),
        ),
        loginPageBloc.isLoginPressed
            ? Center(child: CircularProgressIndicator())
            : Container(),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: UniversalVariables.orangeColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            icon: Image.network(
              'https://developers.google.com/identity/images/g-logo.png',
              height: 24.0,
            ),
            label: Text(
              "Sign in with Google",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 18,
              ),
            ),
            onPressed: () async {
              UserCredential? cred = await AuthMethods().handleGoogleSignIn();
              if (!mounted) return;
              if (cred != null) {
                gotoHomePage();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Google Sign-In failed or was canceled."),
                  ),
                );
              }
            },
          ),
        ),
        SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => gotoRegisterPage(),
          icon: Icon(Icons.person_add),
          label: Text(
            "New User ? Click Here..",
            style: TextStyle(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  gotoHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  gotoRegisterPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Reset Password"),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: "Enter your email address"),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String email = emailController.text.trim();
                if (email.isNotEmpty) {
                  try {
                    await AuthMethods().handleForgotPassword(email);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Password reset email sent!")),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${e.toString()}")),
                      );
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter an email address.")),
                  );
                }
              },
              child: Text("Send Email"),
            ),
          ],
        );
      },
    );
  }
}
