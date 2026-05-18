import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeService {
  static String publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';

  static Future<bool> makePayment(
    BuildContext context,
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic>? paymentIntent = await createPaymentIntent(
        amount,
        currency,
      );
      if (paymentIntent == null) return false;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Food Delivery App',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment Successful"),
          backgroundColor: Colors.green,
        ),
      );

      return true;
    } on StripeException catch (e) {
      print('Stripe Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment Canceled or Failed"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } catch (e) {
      print('Payment Error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (err) {
      print('Error creating payment intent: ${err.toString()}');
      return null;
    }
  }

  static String calculateAmount(String amount) {
    final int calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
