import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/AuthExceptionHandler.dart';
import '../../models/AuthResultStatus.dart';
import '../../service/AuthService.dart';
import '../HomePage/MyHomePage.dart';
import '../HomePage/PasswordProfilChange.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();
  bool chcking = true;
  var authService = AuthService();

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                Container(
                  margin: EdgeInsets.fromLTRB(1, 0, 0, 21),
                  padding: EdgeInsets.fromLTRB(20, 7, 20, 6),
                  width: 304,
                  decoration: BoxDecoration(
                    color: Color(0xffcfced4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: txtPassword,
                    obscureText: chcking,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (chcking == false) {
                                chcking = true;
                              } else {
                                chcking = false;
                              }
                            });

                            print(chcking);
                          },
                          icon: chcking == true
                              ? Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.black,
                                )
                              : Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.red,
                                ),
                        ),
                        hintText: "Şifre : ",
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                ),
                Container(
                  width: 304,
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: Text(
                      "Şifremi Unuttum",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasswordProfilChange(),
                        ),
                      );
                    },
                  ),
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
                        "Giriş Yap",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _login();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _login() async {
    final status = await authService.signIn(txtEmail.text, txtPassword.text);
    if (status == AuthResultStatus.successful) {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
          (route) => false);
    } else {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
      Fluttertoast.showToast(msg: errorMsg);
    }
  }
}
