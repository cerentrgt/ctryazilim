import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:kapsul_teknoloji/models/AdvertiModel.dart';

class AdvertiService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<AdvertiModel> addAdverti(String name, String mostRecentText,
      String date, String? image, bool noti) async {
    String dateYear =
        "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}";
    String dateHour =
        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
    String datePublic = " ${dateYear.toString()}   ${dateHour} ";

    var ref = firestore.collection("Adverti");
    final Timestamp timestamp = Timestamp.now();

    var documentRef = await ref.add({
      'name': name,
      'mostRecentText': mostRecentText,
      'date': date,
      'userName': auth.currentUser!.displayName.toString(),
      'image': image,
      'datePublic': datePublic,
      'noti': noti,
      'timestamp': timestamp
    });
    return AdvertiModel(
        id: documentRef.id,
        name: name,
        mostRecentText: mostRecentText,
        date: date,
        image: image,
        userName: auth.currentUser!.displayName.toString(),
        datePublic: datePublic,
        noti: noti,
        timestamp: timestamp);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAdverti() {
    var ref = firestore
        .collection("Adverti")
        .orderBy("timestamp", descending: true)
        .snapshots();
    return ref;
  }

  Future<void> remoweAdverti(String docId) {
    var ref = firestore.collection("Adverti").doc(docId).delete();
    return ref;
  }

  Future<void> updateAdverti(String docId, String? image) {
    var ref = firestore.collection("Adverti").doc(docId).update({
      'image': image,
    });
    return ref;
  }
}
