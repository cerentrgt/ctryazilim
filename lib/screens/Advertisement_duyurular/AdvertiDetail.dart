import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/Advertisement_duyurular/AdvertiList.dart';
import 'package:kapsul_teknoloji/service/AdvertiService.dart';

class AdvertiDetail extends StatefulWidget {
  final DocumentSnapshot post;

  const AdvertiDetail({super.key, required this.post});

  @override
  State<AdvertiDetail> createState() => _AdvertiDetailState();
}

class _AdvertiDetailState extends State<AdvertiDetail> {
  var txtName = TextEditingController();
  var txtMostRecentText = TextEditingController();
  var txtDate = TextEditingController();
  var txtdatePublic = TextEditingController();

  var txtUserName = TextEditingController();
  var adverService = AdvertiService();
  var name = FirebaseAuth.instance.currentUser!.displayName;

  @override
  void initState() {
    super.initState();
    txtName.text = widget.post['name'];
    txtMostRecentText.text = widget.post['mostRecentText'];
    txtDate.text = widget.post['date'];
    txtdatePublic.text = widget.post['datePublic'];
    txtUserName.text = widget.post['userName'];
  }

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
        backgroundColor: Color(0xff0d0b28),
        title: Text("Duyuru ${widget.post["name"]}",
            style: TextStyle(
                fontStyle: FontStyle.normal,
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
                margin: EdgeInsets.fromLTRB(0, 0, 0, 19),
                width: 356,
                height: 212,
                child: widget.post["image"] != null
                    ? Image.network(
                        widget.post["image"],
                      )
                    : Icon(
                        Icons.newspaper,
                        color: Colors.black,
                        size: 50,
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
                      "DUYURU ADI ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                        fontWeight: FontWeight.normal,
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
                      "DUYURU DETAYI",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.2125,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  subtitle: Center(
                    child: Text(
                      "${widget.post["mostRecentText"]}",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
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
                      "DUYURU TARİHİ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                        fontWeight: FontWeight.normal,
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
              Column(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Yayınlayan : ${widget.post["userName"]}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Yayın Tarihi: ${widget.post["datePublic"]}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Gerçekleşecek Tarih : ${widget.post["date"]}",
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (widget.post["userName"] == name) goDelete(),
            ],
          ),
        ),
      ),
    );
  }

  Widget goDelete() {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xff0d0b28),
      ),
      child: TextButton(
        child: const Text(
          "Sil",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          showDelete(context);
        },
      ),
    );
  }

  void showDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Duyuruyu Sil',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.2125,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Duyuruyu silmek istediğinize emin misiniz?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.2125,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sil'),
              onPressed: () {
                adverService.remoweAdverti(widget.post.id);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdvertiList(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
