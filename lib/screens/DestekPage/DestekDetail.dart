import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/service/DestekService.dart';

class DestekDetail extends StatefulWidget {
  final DocumentSnapshot post;
  const DestekDetail({super.key, required this.post});

  @override
  State<DestekDetail> createState() => _DestekDetailState();
}

class _DestekDetailState extends State<DestekDetail> {
  var txtName = TextEditingController();
  var txtMostRecentText = TextEditingController();
  var txtDate = TextEditingController();
  var txtDesMod = TextEditingController();
  var desService = DestekService();

  @override
  void initState() {
    super.initState();
    txtName.text = widget.post['userName'];
    txtMostRecentText.text = widget.post['mostRecentText'];
    txtDate.text = widget.post['date'];
    txtDesMod.text = widget.post['desMod'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0d0b28),
        title: Text("${widget.post["desMod"]}",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
                color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(12),
          child: Column(
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
                      "${widget.post["desMod"]} İÇERİĞİ ",
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
                      "GÖNDEREN KULLANICI",
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
                      "${widget.post["userName"]}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.2125,
                        color: Color.fromARGB(204, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
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
                      "GÖNDERME TARİHİ",
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
                      "${widget.post["date"]}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.2125,
                        color: Color.fromARGB(204, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
