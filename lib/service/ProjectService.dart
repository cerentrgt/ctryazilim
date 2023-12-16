import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kapsul_teknoloji/models/ProjectModel.dart';

class ProjectService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<ProjectModel> addProject(String projectName, String mostRecentText,
      String projectStatus, String projectTitle) async {
    var ref = firestore.collection("Project");

    int dateDay = DateTime.now().day;
    int dateMonth = DateTime.now().month;
    int dateYear = DateTime.now().year;
    String datePublic =
        " ${dateDay.toString().toString().padLeft(2, '0')}/${dateMonth.toString().toString().padLeft(2, '0')}/${dateYear.toString()}";

    var documentRef = await ref.add({
      'projectName': projectName,
      'mostRecentText': mostRecentText,
      'date': datePublic,
      'projectTitle': projectTitle,
      'projectStatus': projectStatus,
      'projectUserName': auth.currentUser!.displayName
    });
    return ProjectModel(
        id: documentRef.id,
        projectName: projectName,
        mostRecentText: mostRecentText,
        date: datePublic,
        projectStatus: projectStatus,
        projectTitle: projectTitle,
        projectUserName: auth.currentUser!.displayName.toString());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProject() {
    var ref = firestore.collection("Project").snapshots();
    return ref;
  }

  Future<void> remoweProject(String docId) {
    var ref = firestore.collection("Project").doc(docId).delete();
    return ref;
  }

  Future<void> updateProject(String docId, String projectStatus) {
    var ref = firestore
        .collection("Project")
        .doc(docId)
        .update({'projectStatus': projectStatus});
    return ref;
  }
}
