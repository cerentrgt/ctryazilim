import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kapsul_teknoloji/screens/RaporPage/RaporListPage.dart';

import '../../service/RaporService.dart';

class RaporForm extends StatefulWidget {
  const RaporForm({super.key});

  @override
  State<RaporForm> createState() => _RaporFormState();
}

class _RaporFormState extends State<RaporForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rapor Yükle"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: RaporBody(),
    );
  }
}

class RaporBody extends StatefulWidget {
  @override
  State<RaporBody> createState() => _RaporBodyState();
}

class _RaporBodyState extends State<RaporBody> {
  var raporService = RaporService();

  var auth = FirebaseAuth.instance.currentUser;
  var firebaseStorage = FirebaseStorage.instance;

  int dateDay = DateTime.now().day;
  int dateMonth = DateTime.now().month;
  int dateYear = DateTime.now().year;
  String? firstdate;
  String? finishdate;

  void _showFirstDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        dateDay = value!.day;
        dateMonth = value.month;
        dateYear = value.year;
        firstdate =
            " ${dateDay.toString().padLeft(2, '0')}/${dateMonth.toString().padLeft(2, '0')}/${dateYear.toString()}";
        print(firstdate);
      });
    });
  }

  void _showFinishDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        dateDay = value!.day;
        dateMonth = value.month;
        dateYear = value.year;
        finishdate =
            " ${dateDay.toString().padLeft(2, '0')}/${dateMonth.toString().padLeft(2, '0')}/${dateYear.toString()}";
        print(finishdate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final ButtonStyle style = ElevatedButton.styleFrom(
      primary: Color(0xff0d0b28),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
    );

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 75),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 5),
                  color: Colors.blue.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 10)
            ]),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: buildStartDateField(),
            ),
            SizedBox(height: size.height * 0.03),
            if (firstdate != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: buildFinishDateField(),
              ),
            SizedBox(height: size.height * 0.05),
            if (firstdate != null && finishdate != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: pdfButton(),
              ),
            SizedBox(height: size.height * 0.03),
            if (firstdate != null && finishdate != null)
              ElevatedButton(
                style: style,
                child: const Text(
                  "KAYDET",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      color: Colors.white),
                ),
                onPressed: () {
                  if (finishdate.toString().isEmpty) {
                    Fluttertoast.showToast(msg: "Rapor bitiş tarihi seçiniz.");
                  } else if (firstdate.toString().isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Rapor başlangıç tarihi seçiniz.");
                  } else {
                    Fluttertoast.showToast(msg: "Rapor Formu Ekleniyor..");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RaporListPage(),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  buildStartDateField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ),
          label: Text(
            "Rapor Başlangıç Tarihi : ${firstdate == null ? " " : firstdate}",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          icon: Icon(Icons.date_range_outlined),
          onPressed: _showFirstDatePicker,
        ),
      ],
    );
  }

  buildFinishDateField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ),
          label: Text(
            "Rapor Bitiş Tarihi : ${finishdate == null ? " " : finishdate}",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          icon: Icon(Icons.date_range_outlined),
          onPressed: _showFinishDatePicker,
        ),
      ],
    );
  }

  Widget pdfButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xff0d0b28),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
            ),
            onPressed: () async {
              _onPdfButton(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.paperclip,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Dosya Yükle "),
              ],
            )),
      ],
    );
  }

  Future _onPdfButton(BuildContext? context) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        var str = result.files.single.name.split(".");
        String fileExtension = str.last;

        var uploadTask = firebaseStorage
            .ref()
            .child("RaporPdf")
            .child("${DateTime.now().millisecondsSinceEpoch}.$fileExtension")
            .putFile(file);

        uploadTask.snapshotEvents.listen((event) {});

        var storageRef = await uploadTask;
        var store = await storageRef.ref.getDownloadURL();
        raporService.addRapor(finishdate!, firstdate!, store);

        return store;
      }
    } catch (e) {
      print(e);
    }
  }
}
