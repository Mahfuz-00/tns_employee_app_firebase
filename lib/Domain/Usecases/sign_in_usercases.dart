import '../../Data/Sources/Firebase/firebase_sign_in_remote_source.dart';
import '../../Data/Sources/remote_data_sources.dart';
import '../Repositories/sign_in_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninUseCase {
  final SigninRepository tokenRepository;
  final AuthenticationRemoteDataSource remoteDataSource;

  SigninUseCase(this.tokenRepository, this.remoteDataSource);

  Future<String> login(String email, String password, {bool rememberMe = false}) async {
    try {
      // Call the remote data source's authenticate method
      final token = await remoteDataSource.authenticate(email, password);

      // If "rememberMe" is true, save the email and password locally
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('rememberMe', 'true');
        await prefs.setString('savedEmail', email);
        await prefs.setString('savedPassword', password);
      }

      await tokenRepository.saveToken(token!);

      return token; // Return the token after successful login
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    return await tokenRepository.hasToken();
  }

/*  Future<void> logout() async {
    await tokenRepository.clearToken();
  }*/

  Future<void> logout() async {
    // Firebase sign out
    await FirebaseAuth.instance.signOut();

    // Clear token from local storage or repository
    await tokenRepository.clearToken();
  }
}
