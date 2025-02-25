import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutRemoteDataSource {
  static const _tokenKey = '';

  Future<void> logout() async {
    try {
      print('Signing out with Firebase...');
      // Sign out the current user using Firebase Authentication
      await FirebaseAuth.instance.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);

      // Debugging: Confirm successful logout
      print('User logged out successfully.');
    } catch (e, stackTrace) {
      // Handle any errors during logout
      print('Error during logout: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Failed to log out from firebase');
    }
  }
}