import 'package:cloud_firestore/cloud_firestore.dart';

class PermissionModel {
  String id;
  String uid;
  String name;
  String mostRecentText;
  String date;
  String checking;
  String pdf;
  String userName;
  String mail;

  PermissionModel(
      {required this.id,
      required this.uid,
      required this.name,
      required this.mostRecentText,
      required this.date,
      required this.checking,
      required this.pdf,
      required this.userName,
      required this.mail});

  factory PermissionModel.fromSnapshot(DocumentSnapshot snapshot) {
    return PermissionModel(
        id: snapshot.id,
        uid: snapshot["uid"],
        name: snapshot["name"],
        mostRecentText: snapshot["mostRecentText"],
        date: snapshot["date"],
        checking: snapshot["checking"],
        pdf: snapshot["pdf"],
        userName: snapshot["userName"],
        mail: snapshot["mail"]);
  }
}
