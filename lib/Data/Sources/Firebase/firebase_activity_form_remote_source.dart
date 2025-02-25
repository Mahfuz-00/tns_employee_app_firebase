import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/activity_form.dart';

class ActivityFormRemoteDataSource {
  final FirebaseFirestore firestore;

  ActivityFormRemoteDataSource({required this.firestore});

  Future<void> createActivity(ActivityFormModel activity) async {
    try {
      // Reference to the Firestore collection where activities are stored
      final CollectionReference activitiesCollection =
      firestore.collection('activities');

      // Convert the ActivityFormModel to JSON format
      Map<String, dynamic> activityData = activity.toJson();

      // Add the activity data to Firestore
      await activitiesCollection.add(activityData);

      // Debugging: Confirm successful creation
      print('Activity data sent successfully to Firestore.');
    } catch (e) {
      // Handle any errors during Firestore operation
      print('Error creating activity in Firestore: $e');
      throw Exception('Failed to create activity: $e');
    }
  }
}