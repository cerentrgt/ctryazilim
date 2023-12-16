import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/ButtonPage/ButtonHomePage.dart';

import '../../service/AuthService.dart';
import '../UsersPage/UserPage.dart';

class ProfilUserScreen extends StatefulWidget {
  final String userUid;
  const ProfilUserScreen({super.key, required this.userUid});

  @override
  State<ProfilUserScreen> createState() => _ProfilUserScreenState();
}

class _ProfilUserScreenState extends State<ProfilUserScreen> {
  var authService = AuthService();
  var auth = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: userBody()),
    );
  }

  StreamBuilder userBody() {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('Person')
            .where('uid', isEqualTo: widget.userUid)
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
                  : UserListBody(snapshot);
        });
  }

  Widget UserListBody(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: snapshot.data?.docs.length ?? 0,
        itemBuilder: (context, index) {
          DocumentSnapshot mypost = snapshot.data!.docs[index];
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 41),
                  padding: EdgeInsets.fromLTRB(128, 67, 145, 89),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff0d0b28),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(55),
                      bottomLeft: Radius.circular(48),
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 157,
                      height: 238,
                      child: Image.network(
                        mypost["image"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(63, 20, 63, 101),
                  width: double.infinity,
                  child: Column(
                    children: [
                      itemProfile(
                          'Adı', '${mypost['name']}', CupertinoIcons.person),
                      const SizedBox(height: 10),
                      itemProfile('Soyadı', '${mypost['surName']}',
                          CupertinoIcons.person),
                      const SizedBox(height: 10),
                      itemProfile(
                          'Email', '${mypost['mail']}', CupertinoIcons.mail),
                      const SizedBox(height: 10),
                      itemProfile('Telefon Numarası',
                          '${mypost['phoneNumber']}', CupertinoIcons.phone),
                      const SizedBox(height: 10),
                      itemProfile('Birim', '${mypost['unit']}',
                          CupertinoIcons.rectangle_3_offgrid_fill),
                      const SizedBox(height: 10),
                      itemProfile('Unvanı ', '${mypost['title']}',
                          CupertinoIcons.flowchart_fill),
                      const SizedBox(height: 10),
                      goToHome(),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          comeBack(),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  itemProfile(String title, String subtitle, IconData iconData) {
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
          leading: Icon(iconData),
          tileColor: Colors.white,
        ),
      ),
    );
  }

  Widget goToHome() {
    return Container(
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
          'Anasayfa',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.2125,
            color: Color(0xff000000),
          ),
        ),
        leading: Icon(Icons.home),
        tileColor: Colors.white,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ButtonHomePage(),
              ));
        },
      ),
    );
  }

  Widget comeBack() {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey),
      child: TextButton(
        child: const Text(
          "Geri Dön",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserPage(),
            ),
          );
        },
      ),
    );
  }
}
