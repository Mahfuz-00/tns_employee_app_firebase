import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Core/Config/Constants/app_urls.dart'; // Assuming AppURLS is still used for other purposes
import '../../Models/profile.dart';
import '../../../Domain/Entities/profile_entities.dart';
import '../../../Domain/Repositories/profile_repositories.dart';

abstract class ProfileRemoteSource {
  Future<ProfileEntity> fetchProfile();
}

class ProfileRemoteSourceImpl implements ProfileRemoteSource {
  final FirebaseFirestore firestore;

  ProfileRemoteSourceImpl({required this.firestore});

  @override
  Future<ProfileEntity> fetchProfile() async {
    try {
      // Fetch the current user's UID (assuming Firebase Authentication is used)
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Fetch the profile document from Firestore
      final profileSnapshot = await firestore
          .collection('users') // Replace 'users' with your actual collection name
          .doc('KT95pcGQuUMeQ5O7oE7F') // Use the user's UID as the document ID
          .get();

      print('profile from Firebase : $profileSnapshot');

      if (!profileSnapshot.exists) {
        throw Exception('Profile not found for the user');
      }

      // Extract the profile data from the document
      final profileData = profileSnapshot.data();
      if (profileData == null) {
        throw Exception('No data found in the profile document');
      }

      print('Profile Data: $profileData');

      // Create ProfileModel instance using the data from Firestore
      final profile = ProfileModel.fromJson(profileData);

      print('Profile Name: ${profile.name}'); // Debugging the profile name

      // Return ProfileEntity created from the Profile model
      return ProfileEntity.fromModel(profile);
    } catch (e) {
      print('Error fetching profile: $e');
      throw Exception('Failed to load profile');
    }
  }
}