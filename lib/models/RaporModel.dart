import 'package:cloud_firestore/cloud_firestore.dart';

class RaporModel {
  String uid;
  String userName;
  String pdf;
  String startDate;
  String finishDate;
  String mail;
  String uploadDate;

  RaporModel(
      {required this.uid,
      required this.startDate,
      required this.finishDate,
      required this.pdf,
      required this.userName,
      required this.mail,
      required this.uploadDate});

  factory RaporModel.fromSnapshot(DocumentSnapshot snapshot) {
    return RaporModel(
        uid: snapshot["uid"],
        startDate: snapshot["startDate"],
        finishDate: snapshot["finishDate"],
        pdf: snapshot["pdf"],
        userName: snapshot["userName"],
        mail: snapshot["mail"],
        uploadDate: snapshot["uploadDate"]);
  }
}
