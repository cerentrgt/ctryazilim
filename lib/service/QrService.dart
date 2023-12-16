import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QrService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getQrCode() {
    var ref = firestore
        .collection("QrCode")
        .doc(auth.currentUser!.uid)
        .collection("image")
        .snapshots();
    return ref;
  }
}
