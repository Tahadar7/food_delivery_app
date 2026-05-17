import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/blocs/RegisterPageBloc.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:food_delivery_app/screens/loginpages/login.dart';
import 'package:food_delivery_app/utils/universal_variables.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/blocs/theme_provider.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RegisterPageBloc(), child: RegisterPageContent());
  }
}

class RegisterPageContent extends StatefulWidget {
  @override
  _RegisterPageContentState createState() => _RegisterPageContentState();
}

class _RegisterPageContentState extends State<RegisterPageContent> {
  late RegisterPageBloc registerPageBloc;

  TextEditingController textNameController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();
  TextEditingController textPhoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _hasSubmitted = false;

  @override
  Widget build(BuildContext context) {
    registerPageBloc = Provider.of<RegisterPageBloc>(context);
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
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                ),
              ),
              Form(
                key: _formKey,
                autovalidateMode: _hasSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
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
            radius: 75.0, 
            child: ClipOval(
              child: Image.asset('assets/logo.png'),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        TextFormField(
          validator: (email) => registerPageBloc.validateEmail(email ?? ''),
          controller: textNameController,
          decoration: InputDecoration(hintText: "Email", prefixIcon: Icon(Icons.email)),
        ),
        SizedBox(height: 10),
        TextFormField(
          maxLength: 11,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          validator: (phone) => registerPageBloc.validatePhone(phone ?? ''),
          controller: textPhoneController,
          decoration: InputDecoration(hintText: "Phone No", prefixIcon: Icon(Icons.phone)),
        ),
        SizedBox(height: 10),
        TextFormField(
          validator: (password) => registerPageBloc.validatePassword(password ?? ''),
          controller: textPasswordController,
          obscureText: true, 
          decoration: InputDecoration(hintText: "Password", prefixIcon: Icon(Icons.lock)),
        ),
        SizedBox(height: 30.0),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(UniversalVariables.orangeColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
            ),
            onPressed: registerPageBloc.isRegisterPressed 
                ? null 
                : () async {
              setState(() { _hasSubmitted = true; });
              String? error = await registerPageBloc.validateFormAndRegister(
                _formKey, 
                textNameController.text,
                textPasswordController.text, 
                textPhoneController.text
              );
              if (!mounted) return;
              
              if (error != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Registration successful! Logging in..."))
                );
                gotoHomePage();
              }
            },
            child: Text("Register",
                style: TextStyle(color: UniversalVariables.whiteColor, fontSize: 18)),
          ),
        ),
        registerPageBloc.isRegisterPressed
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              )
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
            label: Text("Sign in with Google",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 18)),
            onPressed: () async {
              UserCredential? cred = await AuthMethods().handleGoogleSignIn();
              if (!mounted) return;
              if (cred != null) {
                gotoHomePage();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Sign-In failed or was canceled.")));
              }
            },
          ),
        ),
        TextButton(
          onPressed: () => gotoLoginPage(),
          child: Text("Already have an account? Login", 
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6))),
        )
      ],
    );
  }

  gotoLoginPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  gotoHomePage() {
    Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false 
    );
  }
}