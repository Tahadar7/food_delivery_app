import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:food_delivery_app/models/user_model.dart';
import 'package:food_delivery_app/resources/databaseSQL.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static final DatabaseReference _userReference = _database.ref().child(
    "Users",
  );

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DatabaseEvent event = await _userReference.child(currentUser.uid).once();
    return UserModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
  }

  Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  Future<UserCredential> handleSignInEmail(
    String email,
    String password,
  ) async {
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  Future<UserCredential> handleSignUp(phone, email, password) async {
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      await addDataToDb(userCredential.user!, email, phone, password);

      await _auth.signOut();
    }
    return userCredential;
  }

  Future<void> addDataToDb(
    User currentUser,
    String emailFallback,
    String phone,
    String password,
  ) async {
    UserModel user = UserModel(
      uid: currentUser.uid,

      email: currentUser.email ?? emailFallback,
      phone: phone,
      password: password,
    );

    await _userReference.child(currentUser.uid).set(user.toMap(user));
  }

  Future<void> handleForgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential?> handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        DatabaseEvent event = await _userReference
            .child(userCredential.user!.uid)
            .once();
        if (event.snapshot.value == null) {
          await addDataToDb(
            userCredential.user!,
            userCredential.user!.email ?? "",
            "",
            "",
          );
        }
      }
      return userCredential;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();

    DatabaseSql databaseSql = DatabaseSql();
    await databaseSql.openDatabaseSql();
    await databaseSql.deleteAllData();
  }
}
