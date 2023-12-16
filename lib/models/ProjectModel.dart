import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  String id;
  String projectName;
  String mostRecentText;
  String date;
  String projectStatus; //proje durumu
  String projectTitle; //proje bölümü
  String projectUserName;

  ProjectModel(
      {required this.id,
      required this.projectName,
      required this.mostRecentText,
      required this.date,
      required this.projectStatus,
      required this.projectTitle,
      required this.projectUserName});

  factory ProjectModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ProjectModel(
        id: snapshot.id,
        projectName: snapshot["projectName"],
        mostRecentText: snapshot["mostRecentText"],
        date: snapshot["date"],
        projectStatus: snapshot["projectStatus"],
        projectUserName: snapshot["projectUserName"],
        projectTitle: snapshot["projectTitle"]);
  }
}
