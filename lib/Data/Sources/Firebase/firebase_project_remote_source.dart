import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ProjectRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchProjects();
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final FirebaseFirestore firestore;

  ProjectRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<Map<String, dynamic>>> fetchProjects() async {
    try {
      // Reference to the Firestore collection where projects are stored
      final CollectionReference projectsCollection =
      firestore.collection('projects');

      // Fetch all documents in the 'projects' collection
      QuerySnapshot querySnapshot = await projectsCollection.get();

      // Debugging: Print the number of documents retrieved
      print('Number of projects fetched: ${querySnapshot.docs.length}');

      // Convert the documents into a list of maps
      List<Map<String, dynamic>> projects = querySnapshot.docs.map((doc) {
        Map<String, dynamic> projectData = doc.data() as Map<String, dynamic>;
        print('Project Data: $projectData');
        // projectData['id'] = doc.id as int; // Include the document ID in the data
        return projectData;
      }).toList();

      // Debugging: Print the fetched projects
      print('Fetched projects: $projects');

      return projects;
    } catch (e) {
      // Handle any errors during Firestore operation
      print('Error fetching projects from Firestore: $e');
      throw Exception('Failed to fetch projects from firestore: $e');
    }
  }
}