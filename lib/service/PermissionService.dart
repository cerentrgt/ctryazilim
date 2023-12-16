import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kapsul_teknoloji/models/PermissionModel.dart';

class PermissionService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<PermissionModel> addPermission(String name, String mostRecentText,
      String date, String checking, String pdf, String mail) async {
    String uid = auth.currentUser!.uid;
    var ref = firestore.collection("Permission");

    var documentRef = await ref.add({
      'name': name,
      'mostRecentText': mostRecentText,
      'date': date,
      'checking': checking,
      'pdf': pdf,
      'uid': uid,
      'userName': auth.currentUser!.displayName.toString(),
      'mail': mail
    });
    return PermissionModel(
        id: documentRef.id,
        name: name,
        uid: uid,
        mostRecentText: mostRecentText,
        date: date,
        checking: checking,
        pdf: pdf,
        userName: auth.currentUser!.displayName.toString(),
        mail: mail);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPermission() {
    var ref = firestore
        .collection("Permission")
        .where("uid", isGreaterThanOrEqualTo: auth.currentUser!.uid)
        .snapshots();
    return ref;
  }

  Future<void> remowePermission(String docId) {
    var ref = firestore.collection("Permission").doc(docId).delete();
    return ref;
  }

  Future<void> updatePermission(String docId, String checking) {
    var ref = firestore
        .collection("Permission")
        .doc(docId)
        .update({'checking': checking});
    return ref;
  }

  Future<void> updatePdfPermission(String docId, String pdf) {
    var ref =
        firestore.collection("Permission").doc(docId).update({'pdf': pdf});
    return ref;
  }
}
