import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/PermissionPage/UserPermission/PermisDetail.dart';
import 'package:kapsul_teknoloji/service/PermissionService.dart';
import 'package:url_launcher/url_launcher.dart';

import 'PermissionForm.dart';

class PermissionList extends StatefulWidget {
  const PermissionList({super.key});

  @override
  State<PermissionList> createState() => _PermissionListState();
}

class _PermissionListState extends State<PermissionList> {
  var auth = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;
  var perService = PermissionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff0d0b28),
          child: Icon(Icons.add_box_rounded),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PermissionForm()));
          }),
      appBar: AppBar(
        title: const Text("İZİN TALEPLERİM"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: _body(),
    );
  }

  StreamBuilder _body() {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("Permission")
            .where('uid', isEqualTo: auth!.uid)
            .snapshots(),
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
        itemBuilder: (context, index) {
          DocumentSnapshot mypost = snapshot.data!.docs[index];
          return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: itemProfile(mypost['name'], mypost["mostRecentText"],
                  mypost['checking'], mypost));
        });
  }

  itemProfile(
      String title, String subtitle, String mypost, DocumentSnapshot post) {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PermisDetail(post: post)));
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
}
