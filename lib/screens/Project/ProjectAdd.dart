import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kapsul_teknoloji/screens/Project/ProjectList.dart';
import 'package:kapsul_teknoloji/service/ProjectService.dart';

import '../../service/NotiService.dart';

class ProjectAdd extends StatefulWidget {
  const ProjectAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectAddState();
}

class _ProjectAddState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proje EKLE"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: ProjectAddBody(),
    );
  }
}

class ProjectAddBody extends StatefulWidget {
  @override
  State<ProjectAddBody> createState() => _ProjectAddBodyState();
}

class _ProjectAddBodyState extends State<ProjectAddBody> {
  var projService = ProjectService();
  var notiService = NotiService();

  var txtName = TextEditingController();
  var txtMostRecentText = TextEditingController();
  @override
  void initState() {
    notiService.initialiseNotifications();
    super.initState();
  }

  String projectStatus = "Devam Ediyor";

  String dropdownvalue = "Proje Bölümü Seçiniz";
  var items = [
    'Proje Bölümü Seçiniz',
    'Akıllı Sehirler',
    'Item 2',
    'Bilgi Teknoloji'
  ];

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

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildNameField(),
            SizedBox(height: size.height * 0.03),
            buildMostRecentTextField(),
            SizedBox(height: size.height * 0.03),
            buildProjectTitleField(),
            SizedBox(height: size.height * 0.03),
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
                if (txtName.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Proje adını doldurunuz.");
                } else if (txtMostRecentText.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Proje içeriğini doldurunuz.");
                } else if (dropdownvalue == "Proje Bölümü Seçiniz") {
                  Fluttertoast.showToast(msg: "Lütfen, Proje bölümü seçiniz.");
                } else {
                  projService.addProject(txtName.text.toUpperCase(),
                      txtMostRecentText.text, projectStatus, dropdownvalue);
                  Fluttertoast.showToast(msg: "Proje eklendi..");
                  notiService.sendNotifiation("Yeni Proje Eklendi",
                      "${txtName.text} ${txtMostRecentText.text}");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectList(),
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

  buildNameField() {
    return TextField(
      decoration: const InputDecoration(labelText: "Proje Adı?"),
      textCapitalization: TextCapitalization.words,
      maxLength: 40,
      controller: txtName,
    );
  }

  buildProjectTitleField() {
    return DropdownButton(
      value: dropdownvalue,
      items: [
        DropdownMenuItem(
          child: Text(
            "Proje Bölümü Seçiniz",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.2125,
              color: Colors.red,
            ),
          ),
          value: "Proje Bölümü Seçiniz",
        ),
        DropdownMenuItem(
          child: Text(
            "Akıllı Sehirler",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.2125,
              color: Colors.black,
            ),
          ),
          value: "Akıllı Sehirler",
        ),
        DropdownMenuItem(
          child: Text(
            "Bilgi Teknoloji",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.2125,
              color: Colors.black,
            ),
          ),
          value: "Bilgi Teknoloji",
        ),
      ],
      onChanged: (String? value) {
        setState(() {
          dropdownvalue = value.toString();
        });
      },
    );
  }

  buildMostRecentTextField() {
    return TextField(
      decoration: const InputDecoration(labelText: "PROJE İÇERİĞİ?"),
      textCapitalization: TextCapitalization.words,
      controller: txtMostRecentText,
    );
  }
}
