import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/Advertisement_duyurular/AdvertiAdd.dart';
import 'package:kapsul_teknoloji/service/AdvertiService.dart';

import 'AdvertiDetail.dart';

class AdvertiList extends StatefulWidget {
  const AdvertiList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdvertiListState();
}

class _AdvertiListState extends State {
  var advertiService = AdvertiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Duyuru Panosu"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: body(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 66, 57, 197),
        onPressed: () {
          goToMemoryAdd();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  StreamBuilder body() {
    return StreamBuilder<QuerySnapshot>(
        stream: advertiService.getAdverti(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const CircularProgressIndicator(
                  color: Colors.indigo,
                )
              : snapshot.data == null
                  ? const CircularProgressIndicator(
                      color: Colors.indigo,
                    )
                  : PageView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        DocumentSnapshot mypost = snapshot.data!.docs[index];
                        return Card(
                          elevation: 10,
                          shadowColor: Colors.black,
                          margin: EdgeInsets.all(25.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          color: Color(0xff0d0b28),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 19),
                                      width: 356,
                                      height: 212,
                                      child: mypost["image"] != null
                                          ? ElevatedButton(
                                              onPressed: () {
                                                goToDetail(mypost);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xff0d0b28),
                                                  padding: EdgeInsets.all(
                                                      0) // Düğme iç içe boşluğunu sıfıra ayarlayın
                                                  ),
                                              child: Image.network(
                                                mypost["image"],
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                goToDetail(mypost);
                                              },
                                              icon: Icon(
                                                Icons.newspaper,
                                                color: Colors.white,
                                                size: 100,
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      mypost["name"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      mypost["mostRecentText"],
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                      maxLines: 10,
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "Yayınlayan : ${mypost["userName"]}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "Yayın Tarihi: ${mypost["datePublic"]}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "Gerçekleşecek Tarih : ${mypost["date"]}",
                                            maxLines: 6,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
        });
  }

  void goToMemoryAdd() async {
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AdvertiAdd()));
  }

  void goToDetail(DocumentSnapshot post) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertiDetail(post: post),
      ),
    );
  }
}
