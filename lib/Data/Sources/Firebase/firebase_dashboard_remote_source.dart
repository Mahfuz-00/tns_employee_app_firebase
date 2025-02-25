import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Domain/Entities/dashboard_entities.dart';
import '../../Models/dashboard.dart';

abstract class DashboardRemoteSource {
  Future<DashboardEntity> fetchDashboardData();
}

class DashboardRemoteSourceImpl implements DashboardRemoteSource {
  final FirebaseFirestore firestore;

  DashboardRemoteSourceImpl({required this.firestore});

  @override
  Future<DashboardEntity> fetchDashboardData() async {
    QuerySnapshot querySnapshot = await firestore.collection('dashboard').get();
    print('Number of documents: ${querySnapshot.docs.length}');
    for (var doc in querySnapshot.docs) {
      print('Document ID: ${doc.id}, Data: ${doc.data()}');
    }

/*    // Get the current user's UID
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final String userId = user.uid;

    // Fetch the dashboard data for the current user
    DocumentSnapshot snapshot =
    await firestore.collection('dashboard').doc(userId).get();*/


    // Instead of fetching a token, we directly access Firestore.
    // For example, read a document from the "dashboard" collection.
    DocumentSnapshot snapshot =
    await firestore.collection('dashboard').doc('KT95pcGQuUMeQ5O7oE7F').get();

    // Debugging: Print the snapshot metadata
    print('Snapshot exists: ${snapshot.exists}');
    print('Snapshot data: ${snapshot.data()}');

    if (!snapshot.exists) {
      print('Dashboard data not found.');
      throw Exception('Dashboard data not found.');
    }

    // Convert the document data to a Map.
    final Map<String, dynamic> rawData = snapshot.data() as Map<String, dynamic>;
    if (rawData == null || !rawData.containsKey('data')) {
      print('The "data" field is missing in the document.');
      throw Exception('Invalid Firestore structure: Missing "data" field.');
    }

    final Map<String, dynamic> data = rawData['data'] as Map<String, dynamic>;
    print('Data: $data');

    // Debug prints (similar to your original code)
    print('Data: $data');
    if (data.containsKey('message')) {
      print('Message: ${data['message']}');
    }
    if (data.containsKey('activities')) {
      print('Activities: ${data['activities']}');
    }
    if (data.containsKey('ActivitiesPanding')) {
      print('Activities Pending: ${data['ActivitiesPanding']}');
    }
    if (data.containsKey('AvailableLeave')) {
      print('Available Leave: ${data['AvailableLeave']}');
    }
    if (data.containsKey('UsedLeave')) {
      print('Used Leave: ${data['UsedLeave']}');
    }
    if (data.containsKey('attendance')) {
      print('Attendance: ${data['attendance']}');
    }
    if (data.containsKey('voucher')) {
      print('Voucher: ${data['voucher']}');
    }
    if (data.containsKey('leave')) {
      print('Leave: ${data['leave']}');
    }

    try {
      // Assuming DashboardModel.fromJson accepts the same JSON structure.
      DashboardModel model = DashboardModel.fromJson(data);
      print('Model: $model');
      return model.toEntity();
    } catch (e, stackTrace) {
      print('Error deserializing DashboardModel: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Failed to parse dashboard data.');
    }
  }
}