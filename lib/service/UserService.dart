import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    var ref = firestore
        .collection('Person')
        .where('uid', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
    return ref;
  }

  Future<void> updateUser(
    String docId,
    String online,
  ) {
    var ref = firestore.collection("Person").doc(docId).update({
      'online': online,
    });
    return ref;
  }
}
