import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kapsul_teknoloji/screens/Project/ProjectList.dart';

import '../../service/ProjectService.dart';

class ProjectDetail extends StatefulWidget {
  final DocumentSnapshot post;
  const ProjectDetail({super.key, required this.post});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

List<String> options = ['Devam Ediyor', 'Tamamlandı'];

class _ProjectDetailState extends State<ProjectDetail> {
  String currentOption = options[0];

  var txtName = TextEditingController();
  var txtMostRecentText = TextEditingController();
  var projectService = ProjectService();
  var name = FirebaseAuth.instance.currentUser!.displayName;

  @override
  void initState() {
    super.initState();
    txtName.text = widget.post['projectName'];
    txtMostRecentText.text = widget.post['mostRecentText'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0d0b28),
        title: Text("Proje Güncelleme",
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
                      "PROJE ADI ",
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
                      " ${widget.post["projectName"]}",
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
                      "PROJE DETAYI",
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
                      "${widget.post["mostRecentText"]}",
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
              if (widget.post["projectUserName"] == name)
                ListTile(
                  title: Text(
                    "Devam Ediyor",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: Colors.black,
                    ),
                  ),
                  leading: Radio(
                      value: options[0],
                      groupValue: currentOption,
                      onChanged: (value) {
                        setState(() {
                          currentOption = value!;
                        });
                      }),
                ),
              if (widget.post["projectUserName"] == name)
                ListTile(
                  title: Text(
                    "Tamamlandı",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.2125,
                      color: Colors.black,
                    ),
                  ),
                  leading: Radio(
                      value: options[1],
                      groupValue: currentOption,
                      onChanged: (value) {
                        setState(() {
                          currentOption = value!;
                        });
                      }),
                ),
              SizedBox(
                height: 10,
              ),
              if (widget.post["projectUserName"] == name) goUpdate(),
              SizedBox(
                height: 10,
              ),
              if (widget.post["projectUserName"] == name) goDelete(),
            ],
          ),
        ),
      ),
    );
  }

  Widget goUpdate() {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xff0d0b28),
      ),
      child: TextButton(
        child: const Text(
          "Güncelle",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          projectService.updateProject(widget.post.id, currentOption);
          Fluttertoast.showToast(msg: "Proje güncellendi.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProjectList(),
            ),
          );
        },
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
            'Projeyi Sil',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.2125,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Projeyi silmek istediğinize emin misiniz?',
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
                projectService.remoweProject(widget.post.id);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectList(),
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
