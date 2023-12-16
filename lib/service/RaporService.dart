import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/RaporModel.dart';

class RaporService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<RaporModel> addRapor(
    String finishDate,
    String startDate,
    String pdf,
  ) async {
    String uid = auth.currentUser!.uid;
    var ref = firestore.collection("Report");
    int dateDay = DateTime.now().day;
    int dateMonth = DateTime.now().month;
    int dateYear = DateTime.now().year;
    String uploadDate =
        " ${dateDay.toString().toString().padLeft(2, '0')}/${dateMonth.toString().toString().padLeft(2, '0')}/${dateYear.toString()}";

    await ref.add({
      'pdf': pdf,
      'finishDate': finishDate,
      'startDate': startDate,
      'uid': uid,
      'userName': auth.currentUser!.displayName.toString(),
      'mail': auth.currentUser!.email,
      'uploadDate': uploadDate
    });
    return RaporModel(
        uploadDate: uploadDate,
        finishDate: finishDate,
        startDate: startDate,
        uid: uid,
        pdf: pdf,
        userName: auth.currentUser!.displayName.toString(),
        mail: auth.currentUser!.email.toString());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyRapor() {
    var ref = firestore
        .collection("Report")
        .where("uid", isGreaterThanOrEqualTo: auth.currentUser!.uid)
        .snapshots();
    return ref;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRapor() {
    var ref = firestore.collection("Report").snapshots();
    return ref;
  }
}
