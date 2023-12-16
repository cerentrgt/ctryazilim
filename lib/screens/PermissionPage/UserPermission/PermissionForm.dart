import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kapsul_teknoloji/service/PermissionService.dart';

import 'PermissionList.dart';
import '../pdfView/orderPdfView.dart';

class PermissionForm extends StatefulWidget {
  const PermissionForm({super.key});

  @override
  State<PermissionForm> createState() => _PermissionFormState();
}

class _PermissionFormState extends State<PermissionForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İzin Talebi Oluştur"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: PermissionBody(),
    );
  }
}

class PermissionBody extends StatefulWidget {
  @override
  State<PermissionBody> createState() => _PermissionBodyState();
}

List<String> options = ['Tam Gün İzin', 'İşe Geç Giriş', 'İşten Erken Çıkış'];

class _PermissionBodyState extends State<PermissionBody> {
  String currentOption = options[0];
  TimeOfDay _selectedTime = TimeOfDay.now();

  String? timer = "${DateTime.now().hour}:${DateTime.now().minute}";

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        timer = "${_selectedTime.hour}:${_selectedTime.minute}";
      });
    }
  }

  var perService = PermissionService();
  var txtname = TextEditingController();
  var txtMostRecentText = TextEditingController();

  var auth = FirebaseAuth.instance.currentUser;

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

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: buildMostRecentTextField(),
          ),
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: buildNameField(),
          ),
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: buildDateField(),
          ),
          SizedBox(height: size.height * 0.05),
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
              if (txtMostRecentText.text.isEmpty) {
                Fluttertoast.showToast(msg: "Mazeret Sebebini doldurunuz.");
              } else if (date.toString().isEmpty) {
                Fluttertoast.showToast(
                    msg: "İzin istediğiniz tarihi işaretleyiniz.");
              } else {
                orderPdfView(
                  context,
                  auth!.displayName!,
                  txtMostRecentText.text,
                  date!,
                  "${currentOption} : ${timer}",
                  auth!.email!,
                );
                Fluttertoast.showToast(msg: "İzin Talebi Gönderiliyor..");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PermissionList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  buildNameField() {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Tam Gün İzin',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          leading: Radio(
            groupValue: currentOption,
            value: options[0],
            onChanged: (value) {
              setState(() {
                currentOption = value.toString();
              });
            },
          ),
        ),
        ListTile(
          title: Text(
            'İşe Geç Giriş',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          leading: Radio(
            groupValue: currentOption,
            value: options[1],
            onChanged: (value) {
              setState(() {
                currentOption = value.toString();
              });
            },
          ),
        ),
        if (currentOption == options[1])
          Container(
            width: 300,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 5),
                      color: Colors.blue.withOpacity(.2),
                      spreadRadius: 2,
                      blurRadius: 10)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Giriş Saati: ${_selectedTime.hour}:${_selectedTime.minute}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () => _selectTime(context),
                  child: Row(
                    children: [
                      Text('Saat Seç'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ListTile(
          title: Text(
            'İşten Erken Çıkış',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          leading: Radio(
            groupValue: currentOption,
            value: options[2],
            onChanged: (value) {
              setState(() {
                currentOption = value.toString();
              });
            },
          ),
        ),
        if (currentOption == options[2])
          Container(
            width: 300,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 5),
                      color: Colors.blue.withOpacity(.2),
                      spreadRadius: 2,
                      blurRadius: 10)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Çıkış Saati: ${_selectedTime.hour}:${_selectedTime.minute}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () => _selectTime(context),
                  child: Row(
                    children: [
                      Text('Saat Seç'),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  buildDateField() {
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
            "TARİH",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          icon: Icon(Icons.date_range_outlined),
          onPressed: _showDatePicker,
        ),
      ],
    );
  }

  buildMostRecentTextField() {
    return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 226, 221, 221),
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(20),
          ),
        ),
        child: TextField(
          decoration: const InputDecoration(
              labelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              labelText: "  İZİN SEBEBİ?",
              border: InputBorder.none),
          textCapitalization: TextCapitalization.words,
          controller: txtMostRecentText,
        ));
  }
}
