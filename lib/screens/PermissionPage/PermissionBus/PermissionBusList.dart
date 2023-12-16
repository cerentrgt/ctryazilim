import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'PermissionDetail.dart';

class PermissionBusList extends StatefulWidget {
  const PermissionBusList({super.key});

  @override
  State<PermissionBusList> createState() => _PermissionBusListState();
}

class _PermissionBusListState extends State<PermissionBusList> {
  var auth = FirebaseAuth.instance.currentUser;
  var email = FirebaseAuth.instance.currentUser?.email ?? " ";
  var firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İZİN TALEPLERİ"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: _body(),
    );
  }

  StreamBuilder _body() {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("Permission").snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const CircularProgressIndicator(
                  color: Colors.indigo,
                )
              : snapshot.data == null
                  ? const CircularProgressIndicator(
                      color: Colors.indigo,
                    )
                  : PermissionListBody(snapshot);
        });
  }

  ListView PermissionListBody(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data?.docs.length ?? 0,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        itemBuilder: (context, index) {
          DocumentSnapshot mypost = snapshot.data!.docs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: itemProfile(
              mypost['userName'],
              mypost["name"],
              mypost['checking'],
              mypost,
              mypost["pdf"],
            ),
          );
        });
  }

  itemProfile(String title, String subtitle, String mypost,
      DocumentSnapshot post, String pdf) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 5),
                  color: Colors.blue.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 10)
            ]),
        child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.2125,
                color: Color(0xff000000),
              ),
            ),
            subtitle: Text(subtitle),
            leading: IconButton(
              icon: Icon(
                Icons.download,
                color: Colors.blue[900],
              ),
              onPressed: () {
                _launchUrl(pdf);
              },
            ),
            trailing: mypost == "İzin verildi"
                ? Text(
                    mypost,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                        fontStyle: FontStyle.italic,
                        fontSize: 13),
                  )
                : Text(
                    mypost,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                        fontSize: 13),
                  ),
            tileColor: Colors.white,
            onTap: () {
              goToDetail(post);
            }),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Url bulunamadı";
    }
  }

  void goToDetail(DocumentSnapshot post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PermissionDetail(post: post),
      ),
    );
  }
}
