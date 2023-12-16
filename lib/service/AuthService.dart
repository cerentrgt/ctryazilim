import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/AuthExceptionHandler.dart';
import '../models/AuthResultStatus.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late AuthResultStatus _status;

  String mediaUrl = "";

//email ile giriş
  Future<AuthResultStatus> signIn(String email, String password) async {
    try {
      final authResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  //oturum kapatma
  signOut() async {
    return await auth.signOut();
  }

  //şifre değiştirme

  Future<void> passwordReset(BuildContext context, String email) async {
    var reset = await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => Navigator.of(context).pop());
    return reset;
  }
}
