import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRemoteDataSource {

  // Authenticate user using Firebase Authentication
  Future<String?> authenticate(String email, String password) async {
    try {
      print('Authenticating Email: $email');
      print('Authenticating Password: $password');
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(userCredential);

      final user = userCredential.user;
      print(user);
      if (user != null) {
        return await user.getIdToken(); // Returns the Firebase ID token
      } else {
        throw Exception("User not found.");
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      print("Firebase Auth Error Code: ${e.code}");
      print("Firebase Auth Error Message: ${e.message}");
      //  throw Exception("Login failed: ${e.code}"); // Propagate the exact error
      if (e.code == 'user-not-found') {
        throw Exception("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Wrong password provided.");
      } else {
        throw Exception("Authentication failed: ${e.message}");
      }
    } catch (e, stackTrace) {
      print("🚨 Generic Error: $e");
      print("Stack trace: $stackTrace");
      throw Exception("Error in Firebase sign-in authentication: $e");
    }
  }
}
