import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/activity.dart';

class ActivityRemoteDataSource {
  final FirebaseFirestore firestore;

  ActivityRemoteDataSource({required this.firestore});

  // Fetch tasks from Firestore
  Future<List<ActivityModel>> getTasks() async {
    try {
      // Reference to the Firestore collection where activities are stored
      final CollectionReference activitiesCollection =
      firestore.collection('activities');

      // Fetch all documents in the 'activities' collection
      QuerySnapshot querySnapshot = await activitiesCollection.get();

      // Debugging: Print the number of documents retrieved
      print('Number of activities fetched: ${querySnapshot.docs.length}');

      // Convert the documents into a list of ActivityModel instances
      List<ActivityModel> activities = querySnapshot.docs.map((doc) {
        Map<String, dynamic> activityData = doc.data() as Map<String, dynamic>;
        print('Activity data $activityData');
        // activityData['id'] = doc.id; // Include the document ID in the data
        return ActivityModel.fromJson(activityData);
      }).toList();

      // Debugging: Print the fetched activities
      print('Fetched activities: $activities');

      return activities;
    } catch (e) {
      // Handle any errors during Firestore operation
      print('Error fetching activities from Firestore: $e');
      throw Exception('Failed to fetch activities: $e');
    }
  }
}