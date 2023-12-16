import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/ButtonPage/ButtonHomePage.dart';
import 'package:kapsul_teknoloji/screens/HomePage/PasswordProfilChange.dart';
import 'package:kapsul_teknoloji/screens/QrCode/QrCode.dart';

import '../../service/AuthService.dart';
import '../LoginPage/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var authService = AuthService();
  var auth = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                child: InkWell(
                  child: CircleAvatar(
                    radius: 85,
                    backgroundImage: NetworkImage(
                      auth!.photoURL!,
                    ),
                  ),
                ),
              ),
              Container(
                // merhabagizem7aX (5:24)
                margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: Text(
                  'Merhaba ${auth!.displayName}!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    height: 1.2125,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(63, 20, 63, 101),
                width: double.infinity,
                child: userBody(),
              )
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder userBody() {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('Person')
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
          return Column(
            children: [
              itemProfile('Email', '${auth!.email}', CupertinoIcons.mail),
              const SizedBox(height: 10),
              itemProfile('Telefon Numarası', '${mypost['phoneNumber']}',
                  CupertinoIcons.phone),
              const SizedBox(height: 10),
              itemProfile('Birim', '${mypost['unit']}',
                  CupertinoIcons.rectangle_3_offgrid_fill),
              const SizedBox(height: 10),
              itemProfile('Unvanı ', '${mypost['title']}',
                  CupertinoIcons.flowchart_fill),
              const SizedBox(height: 10),
              goToQr(),
              const SizedBox(height: 10),
              goToHome(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  passwordChange(),
                  SizedBox(
                    width: 15,
                  ),
                  goOut(mypost['name']),
                ],
              ),
            ],
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

  Widget goToQr() {
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
          'Qr Kod',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.2125,
            color: Color(0xff000000),
          ),
        ),
        leading: Icon(Icons.qr_code),
        tileColor: Colors.white,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrCode(),
              ));
        },
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

  Widget passwordChange() {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey),
      child: TextButton(
        child: const Text(
          "Şifre Değiştir",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordProfilChange(),
            ),
          );
        },
      ),
    );
  }

  Widget goOut(String name) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.red),
      child: TextButton(
        child: const Text(
          "Çıkış Yap",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          authService.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
      ),
    );
  }
}
