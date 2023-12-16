import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RaporDetail extends StatefulWidget {
  final DocumentSnapshot post;
  const RaporDetail({super.key, required this.post});

  @override
  State<RaporDetail> createState() => _RaporDetailState();
}

class _RaporDetailState extends State<RaporDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0d0b28),
        title: Text("RAPOR DETAYI",
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
                      "İSİM SOYİSİM ",
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
                      "Rapor Başlangıç Tarihi",
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
                      "${widget.post["startDate"]}",
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
                      "Rapor Bitiş Tarihi",
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
                      "${widget.post["finishDate"]}",
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
                        "Rapor Dosyası",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.2125,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    subtitle: IconButton(
                        icon: Icon(
                          Icons.download,
                        ),
                        onPressed: () {
                          _launchUrl(widget.post["pdf"]);
                        })),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Url bulunamadı";
    }
  }
}
