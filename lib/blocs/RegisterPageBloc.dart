import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPageBloc with ChangeNotifier {
  AuthMethods mAuthMethods = AuthMethods();

  bool isRegisterPressed = false;

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

  String? validatePhone(String phone) {
    if (phone.isEmpty || phone.length < 11) {
      return 'Invalid PhoneNo (11 digits required)';
    }
    return null;
  }

  Future<String?> validateFormAndRegister(
    GlobalKey<FormState> formKey,
    String email,
    String password,
    String phone,
  ) async {
    isRegisterPressed = true;
    notifyListeners();

    try {
      if (formKey.currentState?.validate() == true) {
        await mAuthMethods.handleSignUp(phone, email, password);
        return null;
      }
      return "Validation failed";
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Error: ${e.code}");
      if (e.code == 'email-already-in-use') {
        return "Duplicate email. This email already exists.";
      }
      return e.message;
    } catch (e) {
      debugPrint("General Error: $e");
      return e.toString();
    } finally {
      isRegisterPressed = false;
      notifyListeners();
    }
  }
}
