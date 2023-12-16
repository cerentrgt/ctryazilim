import 'package:flutter/material.dart';

import 'QrCodeBody.dart';

class QrCode extends StatefulWidget {
  const QrCode({super.key});

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Qr Kod"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: QrCodeBody(),
    );
  }
}
