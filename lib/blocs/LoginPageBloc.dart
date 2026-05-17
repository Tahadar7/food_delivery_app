import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';

class LoginPageBloc with ChangeNotifier {
  AuthMethods mAuthMethods = AuthMethods();

  bool isLoginPressed = false;

  String? validateEmail(String email) {
    if (email.isEmpty || !EmailValidator.validate(email)) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty || password.length < 6) {
      return 'Password should atleast contain 6 character';
    }
    return null;
  }

  @override
  void notifyListeners() {
    if (hasListeners) {
      super.notifyListeners();
    }
  }

  Future<String?> validateFormAndLogin(
    GlobalKey<FormState> formKey,
    String userName,
    String password,
  ) async {
    isLoginPressed = true;
    notifyListeners();
    try {
      if (formKey.currentState?.validate() == true) {
        await mAuthMethods.handleSignInEmail(userName, password);

        var userDetails = await mAuthMethods.getUserDetails();
        if (userDetails.isAdmin) {
          return "ADMIN_LOGIN_SUCCESS";
        }
        return null;
      }
      return "Form validation failed";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "User not found. Please check your email.";
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return "Wrong credentials. Please try again.";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      isLoginPressed = false;
      notifyListeners();
    }
  }
}
