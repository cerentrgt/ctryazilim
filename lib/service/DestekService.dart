import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/DestekModel.dart';

class DestekService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<DestekModel> addDestek(
      String name, String mostRecentText, String desMod) async {
    String dateYear =
        "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}";
    String dateHour =
        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
    String datePublic = "${dateYear.toString()}   ${dateHour} ";

    await firestore.collection("Destek").add({
      'mostRecentText': mostRecentText,
      'date': datePublic,
      'userName': name,
      'desMod': desMod
    });

    return DestekModel(
        desMod: desMod,
        mostRecentText: mostRecentText,
        date: datePublic,
        userName: name);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDestek() {
    var ref = firestore.collection("Destek").snapshots();
    return ref;
  }
}
