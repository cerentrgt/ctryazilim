import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/service/QrService.dart';

class QrCodeBody extends StatefulWidget {
  const QrCodeBody({super.key});

  @override
  State<QrCodeBody> createState() => _QrCodeBodyState();
}

class _QrCodeBodyState extends State<QrCodeBody> {
  var qrService = QrService();
  var txtUser = FirebaseAuth.instance.currentUser!.displayName;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: qrService.getQrCode(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const CircularProgressIndicator(
                  color: Colors.indigo,
                )
              : snapshot.data == null
                  ? const CircularProgressIndicator(
                      color: Colors.indigo,
                    )
                  : QrCodeBody(snapshot);
        });
  }

  ListView QrCodeBody(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data?.docs.length ?? 0,
        itemBuilder: (context, index) {
          DocumentSnapshot mypost = snapshot.data!.docs[index];
          return Card(
            child: Column(
              children: [
                Image.network(
                  mypost["image"],
                  height: 400,
                  width: 400,
                ),
              ],
            ),
          );
        });
  }
}
