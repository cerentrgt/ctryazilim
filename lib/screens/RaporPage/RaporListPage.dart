import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/RaporPage/RaporForm.dart';
import 'package:kapsul_teknoloji/service/PermissionService.dart';
import 'package:url_launcher/url_launcher.dart';

class RaporListPage extends StatefulWidget {
  const RaporListPage({super.key});

  @override
  State<RaporListPage> createState() => _RaporListPageState();
}

class _RaporListPageState extends State<RaporListPage> {
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => RaporForm()));
          }),
      appBar: AppBar(
        title: const Text("RAPORLARIM"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: _body(),
    );
  }

  StreamBuilder _body() {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("Report")
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
                  : RaporListBody(snapshot);
        });
  }

  ListView RaporListBody(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data?.docs.length ?? 0,
        itemBuilder: (context, index) {
          DocumentSnapshot mypost = snapshot.data!.docs[index];
          return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: itemProfile(mypost['userName'], mypost["uploadDate"],
                  mypost["pdf"], mypost));
        });
  }

  itemProfile(
      String title, String subtitle, String pdf, DocumentSnapshot post) {
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
            trailing: Text(
              subtitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                height: 1.2125,
                color: Color(0xff000000),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.download),
              onPressed: () {
                _launchUrl(pdf);
              },
            ),
            tileColor: Colors.white,
            onTap: () {
              /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PermisDetail(post: post)));*/
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
