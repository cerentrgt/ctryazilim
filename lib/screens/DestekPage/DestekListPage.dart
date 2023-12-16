import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/DestekPage/DestekDetail.dart';
import 'package:kapsul_teknoloji/service/DestekService.dart';

class DestekListPage extends StatefulWidget {
  const DestekListPage({super.key});

  @override
  State<DestekListPage> createState() => _DestekListPageState();
}

class _DestekListPageState extends State<DestekListPage> {
  var desService = DestekService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DESTEK-TALEP-ŞİKAYET",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: desService.getDestek(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
                'Veriler getirilirken bir hata oluştu: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final data = snapshot.data!.docs;

          // Verileri "desMod" alanına göre gruplama
          final groupedData = groupDataByDesMod(data);

          return ListView.builder(
            itemCount: groupedData.length,
            itemBuilder: (BuildContext context, int index) {
              final desMod = groupedData.keys.elementAt(index);
              final groupDocs = groupedData[desMod]!;

              return ExpansionTile(
                title: Text(
                  '$desMod',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.2125,
                    color: Colors.blue,
                  ),
                ),
                children: groupDocs.map((doc) {
                  final dateText = doc["date"];
                  final dateParts = dateText.split(" ");
                  print(dateParts);
                  final date = dateParts[0];
                  return ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DestekDetail(post: doc)));
                    },
                    title: Text(
                      doc["userName"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      doc["mostRecentText"],
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(date),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Map<String, List<DocumentSnapshot>> groupDataByDesMod(
      List<DocumentSnapshot> data) {
    final groupedData = <String, List<DocumentSnapshot>>{};

    for (final doc in data) {
      final desMod = doc["desMod"];

      if (!groupedData.containsKey(desMod)) {
        groupedData[desMod] = [];
      }

      groupedData[desMod]!.add(doc);
    }

    return groupedData;
  }
}
