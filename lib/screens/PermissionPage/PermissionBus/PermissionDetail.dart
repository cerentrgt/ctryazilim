import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kapsul_teknoloji/screens/PermissionPage/PermissionBus/PermissionBusList.dart';
import 'package:kapsul_teknoloji/screens/PermissionPage/pdfView/orderPdfView.dart';
import 'package:kapsul_teknoloji/service/PermissionService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionDetail extends StatefulWidget {
  final DocumentSnapshot post;

  const PermissionDetail({super.key, required this.post});

  @override
  State<PermissionDetail> createState() => _PermissionDetailState();
}

List<String> options = ['İzin verildi', 'Reddedildi'];

class _PermissionDetailState extends State<PermissionDetail> {
  String currentOption = options[0];

  var perService = PermissionService();
  var txtname = TextEditingController();
  var txtMostRecentText = TextEditingController();
  var txtdate = TextEditingController();

  final ButtonStyle style = ElevatedButton.styleFrom(
    primary: Color(0xff0d0b28),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(6),
      ),
    ),
  );

  @override
  void initState() {
    txtname.text = widget.post['name'];
    txtdate.text = widget.post['date'];
    txtMostRecentText.text = widget.post['mostRecentText'];
    loadsSwitchValue();
    super.initState();
  }

  loadsSwitchValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentOption = prefs.getString("currentOption") ?? "";
    });
  }

  savenSwitchValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('currentOption', currentOption);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0d0b28),
        title: Text("${widget.post['name']}",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
                color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 21),
              padding: EdgeInsets.fromLTRB(17, 7, 17, 6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x5e7c7b8b),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListTile(
                title: Center(
                  child: Text(
                    "İSİM SOYİSİM",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    " ${widget.post["userName"]}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: const Color.fromARGB(204, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 21),
              padding: EdgeInsets.fromLTRB(17, 7, 17, 6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x5e7c7b8b),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListTile(
                title: Center(
                  child: Text(
                    "İZİN ADI ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    " ${widget.post["name"]}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: const Color.fromARGB(204, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 21),
              padding: EdgeInsets.fromLTRB(17, 7, 17, 6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x5e7c7b8b),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListTile(
                title: Center(
                  child: Text(
                    "İZİN İÇERİĞİ ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    " ${widget.post["mostRecentText"]}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: const Color.fromARGB(204, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 21),
              padding: EdgeInsets.fromLTRB(17, 7, 17, 6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x5e7c7b8b),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListTile(
                title: Center(
                  child: Text(
                    "TARİH",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    " ${widget.post["date"]}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: const Color.fromARGB(204, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 21),
              padding: EdgeInsets.fromLTRB(17, 7, 17, 6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x5e7c7b8b),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListTile(
                title: Center(
                  child: Text(
                    "DURUMU",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    " ${widget.post["checking"]}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: const Color.fromARGB(204, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.post["checking"] != "İptal Edildi")
              ListTile(
                title: Text(
                  'İzin verildi',
                ),
                leading: Radio(
                  groupValue: currentOption,
                  value: options[0],
                  onChanged: (value) {
                    setState(() {
                      currentOption = value.toString();

                      print(currentOption);

                      savenSwitchValue();
                    });
                  },
                ),
              ),
            if (widget.post["checking"] != "İptal Edildi")
              ListTile(
                title: Text('Reddedildi'),
                leading: Radio(
                  groupValue: currentOption,
                  value: options[1],
                  onChanged: (value) {
                    setState(() {
                      currentOption = value.toString();
                      print(currentOption);

                      savenSwitchValue();
                    });
                  },
                ),
              ),
            SizedBox(height: 15),
            if (widget.post["checking"] != "İptal Edildi")
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
                  if (txtname.text.isEmpty) {
                    Fluttertoast.showToast(msg: "İzin adını doldurunuz.");
                  } else if (txtMostRecentText.text.isEmpty) {
                    Fluttertoast.showToast(msg: "İzin İçeriğini doldurunuz.");
                  } else {
                    perService.updatePermission(widget.post.id, currentOption);

                    updatePdfView(
                        context,
                        widget.post["userName"],
                        txtMostRecentText.text,
                        txtdate.text,
                        txtname.text,
                        widget.post["mail"],
                        currentOption,
                        widget.post.id);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PermissionBusList(),
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
}
