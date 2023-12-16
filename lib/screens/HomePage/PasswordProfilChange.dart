import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kapsul_teknoloji/screens/LoginPage/LoginScreen.dart';
import 'package:kapsul_teknoloji/screens/Profil/ProfileScreen.dart';

import '../../service/AuthService.dart';

class PasswordProfilChange extends StatefulWidget {
  const PasswordProfilChange({super.key});

  @override
  State<PasswordProfilChange> createState() => _PasswordProfilChangeState();
}

class _PasswordProfilChangeState extends State<PasswordProfilChange> {
  var txtEmail = TextEditingController();
  var authService = AuthService();

  @override
  void dispose() {
    txtEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // group3xgw (5:23)
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff0d0b28),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(55),
                  bottomLeft: Radius.circular(48),
                ),
              ),
              child: Center(
                // ekranresmi2023081814311g79 (2:3)
                child: SizedBox(
                  width: 430,
                  height: 315,
                  child: Image.asset("assets/icons/ctrtekno.png"),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(62, 53, 63, 124),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(1, 0, 0, 21),
                    padding: EdgeInsets.fromLTRB(20, 7, 20, 6),
                    width: 304,
                    decoration: BoxDecoration(
                      color: Color(0xffcfced4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextField(
                      controller: txtEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "E-mail :",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xff0d0b28),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          " E-mail Gönder",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          CupertinoIcons.paperplane,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (txtEmail.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "E-mail alanı boş olamaz",
                            backgroundColor: Colors.red,
                          );
                        } else {
                          Fluttertoast.showToast(msg: "E-Mail Gönderildi.");
                          authService.passwordReset(context, txtEmail.text);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xff0d0b28),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          " Geri Dön",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.backspace,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
