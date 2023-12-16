import 'package:cloud_firestore/cloud_firestore.dart';

class DestekModel {
  String mostRecentText;
  String desMod;
  String userName;
  String date;
  DestekModel(
      {required this.date,
      required this.mostRecentText,
      required this.desMod,
      required this.userName});

  factory DestekModel.fromSnapshot(DocumentSnapshot snapshot) {
    return DestekModel(
        mostRecentText: snapshot["mostRecentText"],
        date: snapshot["date"],
        userName: snapshot["userName"],
        desMod: snapshot["desMod"]);
  }
}
