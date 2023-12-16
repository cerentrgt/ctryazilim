import 'package:cloud_firestore/cloud_firestore.dart';

class AdvertiModel {
  String id;
  String name;
  String mostRecentText;
  String date;
  String userName;
  String? image;
  String datePublic;
  final Timestamp timestamp;
  bool noti;

  AdvertiModel(
      {required this.id,
      required this.name,
      required this.mostRecentText,
      required this.date,
      required this.userName,
      required this.datePublic,
      required this.noti,
      required this.timestamp,
      this.image});

  factory AdvertiModel.fromSnapshot(DocumentSnapshot snapshot) {
    return AdvertiModel(
        id: snapshot.id,
        name: snapshot["name"],
        mostRecentText: snapshot["mostRecentText"],
        date: snapshot["date"],
        userName: snapshot["userName"],
        datePublic: snapshot["datePublic"],
        noti: snapshot["noti"],
        timestamp: snapshot["timestamp"],
        image: snapshot["image"]);
  }
}
