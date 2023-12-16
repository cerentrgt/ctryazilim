import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kapsul_teknoloji/screens/Advertisement_duyurular/AdvertiList.dart';
import 'package:kapsul_teknoloji/service/AdvertiService.dart';
import 'package:kapsul_teknoloji/service/NotiService.dart';

class AdvertiAdd extends StatefulWidget {
  const AdvertiAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdvertiAddState();
}

class _AdvertiAddState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AdvertiList()));
            },
            icon: Icon(Icons.arrow_back)),
        title: const Text("DUYURU EKLE"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: AdvertiAddBody(),
    );
  }
}

class AdvertiAddBody extends StatefulWidget {
  @override
  State<AdvertiAddBody> createState() => _AdvertiAddBodyState();
}

class _AdvertiAddBodyState extends State<AdvertiAddBody> {
  var advertService = AdvertiService();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  var auth = FirebaseAuth.instance.currentUser;

  var txtName = TextEditingController();
  var txtMostRecentText = TextEditingController();

  var notiService = NotiService();
  bool noti = false;
  @override
  void initState() {
    notiService.initialiseNotifications();
    super.initState();
  }

  String? storeName;

  int dateDay = DateTime.now().day;
  int dateMonth = DateTime.now().month;
  int dateYear = DateTime.now().year;
  String? date;

  void _showDatePicker() {
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
        date =
            " ${dateDay.toString().padLeft(2, '0')}/${dateMonth.toString().padLeft(2, '0')}/${dateYear.toString()}";
        print(date);
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

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.03),
            buildNameField(),
            SizedBox(height: size.height * 0.03),
            buildMostRecentTextField(),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    onImageButton(ImageSource.camera, context);
                  },
                  iconSize: 40,
                  icon: Icon(
                    Icons.camera_alt_rounded,
                  ),
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    onImageButton(ImageSource.gallery, context);
                  },
                  icon: Icon(Icons.image),
                  iconSize: 40,
                  color: Colors.blue,
                ),
              ],
            ),
            buildDateField(),
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
                  Fluttertoast.showToast(msg: "Duyuru Adını doldurunuz.");
                } else if (txtMostRecentText.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Duyuru İçeriğini doldurunuz.");
                } else if (date == null) {
                  Fluttertoast.showToast(msg: "Duyuru Tarihi ekleyiniz.");
                } else {
                  advertService.addAdverti(
                    txtName.text,
                    txtMostRecentText.text,
                    date!,
                    storeName,
                    noti,
                  );

                  notiService.sendNotifiation("Yeni Duyuru eklendi",
                      "${txtName.text}: ${txtMostRecentText.text}");
                  Fluttertoast.showToast(msg: "Duyuru eklendi.");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdvertiList(),
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

  Future onImageButton(
    ImageSource source,
    BuildContext? context,
  ) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      Fluttertoast.showToast(msg: "Görsel yükleniyor lütfen bekleyiniz.");
      var uploadTask = firebaseStorage
          .ref()
          .child("Adverti")
          .child("${image.name}.${imageTemporary.path.split('.').last}")
          .putFile(imageTemporary);

      uploadTask.snapshotEvents.listen((event) {});

      var storageRef = await uploadTask;
      var store = await storageRef.ref.getDownloadURL();
      setState(() {
        storeName = store;
      });

      Fluttertoast.showToast(msg: "Görsel eklendi.");

      return store;
    } catch (e) {
      print(e);
    }
  }

  buildNameField() {
    return TextField(
      decoration: const InputDecoration(labelText: "Duyuru Başlığı"),
      textCapitalization: TextCapitalization.words,
      maxLength: 40,
      controller: txtName,
    );
  }

  buildDateField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          label: Text(
            "Tarih",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          icon: Icon(Icons.date_range_outlined),
          onPressed: _showDatePicker,
        ),
      ],
    );
  }

  buildMostRecentTextField() {
    return TextField(
      decoration: const InputDecoration(labelText: "Duyuru İçeriği?"),
      textCapitalization: TextCapitalization.words,
      controller: txtMostRecentText,
    );
  }
}
