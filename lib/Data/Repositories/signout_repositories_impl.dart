import 'package:shared_preferences/shared_preferences.dart';
import '../../Domain/Repositories/signout_repositories.dart';
import '../Sources/Firebase/firebase_sign_out_remote_source.dart';

class SignOutRepositoryImpl implements SignOutRepository {
  final SignOutRemoteDataSource remoteDataSource;

/*  print(remoteDataSource) {
    // TODO: implement print
    print(remoteDataSource);
    throw UnimplementedError();
  }*/

  // SignOutRepositoryImpl({required this.remoteDataSource});

  SignOutRepositoryImpl({required this.remoteDataSource}) {
    if (remoteDataSource == null) {
      throw Exception('SignOutRemoteDataSource is null');
    }
    print('SignOutRemoteDataSource successfully injected.');
  }

  @override
  Future<void> logout() async {
    try {
      print('Firebase SignOutRepository');
      // Perform remote logout using Firebase
      await remoteDataSource.logout();

      // Debugging: Confirm successful logout
      print('Logout completed successfully.');
    } catch (e, stackTrace) {
      print('SignOutRepositoryImpl : $remoteDataSource');
      if (remoteDataSource == null) {
        print('remoteDataSource is null in logout()');
        throw Exception('SignOutRemoteDataSource is null');
      } else {
        print('find another way why getting error!!');
      }

      // Handle any errors during logout
      print('Error during logout: $e');
      print('StackTrace : $stackTrace');
      throw Exception('Failed to log out from firebase');
    }
  }
}