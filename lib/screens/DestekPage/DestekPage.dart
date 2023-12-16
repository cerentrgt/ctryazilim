import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../service/DestekService.dart';

class DestekPage extends StatefulWidget {
  const DestekPage({super.key});

  @override
  State<DestekPage> createState() => _DestekPageState();
}

class _DestekPageState extends State<DestekPage> {
  var txtMostRecenText = TextEditingController();
  var desService = DestekService();
  var userName = FirebaseAuth.instance.currentUser!.displayName;
  bool chcking = false;

  String dropdownvalue = "Şikayet";
  var items = [
    'Şikayet',
    'Destek Talep',
    'Proje Fikri',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${dropdownvalue.toUpperCase()}",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 100),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: 400, // Dropdown açıldığında genişletilmiş boyut
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  color: const Color.fromARGB(255, 192, 191, 191),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownvalue,
                      items: [
                        DropdownMenuItem<String>(
                          child: Text(
                            "Şikayet",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.2125,
                              color: Colors.red,
                            ),
                          ),
                          value: "Şikayet",
                        ),
                        DropdownMenuItem<String>(
                          child: Text(
                            "Destek Talep",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.2125,
                              color: Colors.red,
                            ),
                          ),
                          value: "Destek Talep",
                        ),
                        DropdownMenuItem<String>(
                          child: Text(
                            "Proje Fikri",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.2125,
                              color: Colors.red,
                            ),
                          ),
                          value: "Proje Fikri",
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          dropdownvalue = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Wrap(spacing: 10.0, runSpacing: 10.0, children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: txtMostRecenText,
                    maxLines: null, // Birden fazla satır
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      hintText: '${dropdownvalue} yazınız...',
                      labelStyle: TextStyle(
                        color: Color(0xFF6200EE),
                      ),
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "İsminiz görünsün mü? ${chcking == true ? "Evet" : "Hayır"} ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (chcking == false) {
                          chcking = true;
                        } else {
                          chcking = false;
                        }
                      });
                    },
                    icon: chcking == true
                        ? Icon(
                            CupertinoIcons.person_badge_plus,
                            color: Colors.red,
                          )
                        : Icon(
                            CupertinoIcons.person_badge_minus,
                            color: Colors.black,
                          ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff0d0b28),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                ),
                child: const Text(
                  "GÖNDER",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      color: Colors.white),
                ),
                onPressed: () {
                  if (txtMostRecenText.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Duyuru İçeriğini doldurunuz.");
                  } else {
                    desService.addDestek(
                        chcking == true ? userName.toString() : "İsimsiz",
                        txtMostRecenText.text,
                        dropdownvalue);
                    Fluttertoast.showToast(msg: "${dropdownvalue} gönderildi.");
                    txtMostRecenText.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
