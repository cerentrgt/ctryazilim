import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/service/UserService.dart';

import '../ChatPage/ChatPage.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var userService = UserService();
  var auth = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;

  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "KULLANICILAR",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xff0d0b28),
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Kullanıcı Ara",
                  hintText: "Kullanıcı adı",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              buildUserList(),
            ],
          ),
        ));
  }

  Widget buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: userService.getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Yükleniyor");
        }

        return Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            children: snapshot.data!.docs
                .map<Widget>((e) => buildUserListItem(e))
                .toList(),
          ),
        );
      },
    );
  }

  Widget buildUserListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    String online = "Çevrimiçi";
    userService.updateUser(auth!.uid, online);

    if (name.isEmpty) {
      return ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Colors.blue),
          borderRadius: BorderRadius.circular(50),
        ),
        leading: CircleAvatar(
            backgroundImage: NetworkImage(
              data['image'],
            ),
            child: data['online'] == "Çevrimiçi"
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.circle, color: Colors.green, size: 14),
                  )
                : Align(
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.circle, color: Colors.red, size: 14),
                  ),
            radius: 30,
            backgroundColor: Colors.white),
        title: Row(
          children: [
            Text(
              data['name'],
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              data['surName'],
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        subtitle: Text(
          data['mail'],
        ),
        onTap: () {
          String fullName = data['name'] + " " + data['surName'];

          print(data['uid']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                online: data['online'],
                receiverUserID: data['uid'],
                receiverName: fullName,
                userMail: data['mail'],
                receiverEmail: auth!.email!,
                senderName: auth!.displayName!,
                senderUserID: auth!.uid,
                image: data['image'],
              ),
            ),
          );
        },
      );
    }
    if (data['name'].toString().toLowerCase().contains(name.toLowerCase())) {
      return ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Colors.blue),
          borderRadius: BorderRadius.circular(50),
        ),
        leading: CircleAvatar(
            backgroundImage: NetworkImage(
              data['image'],
            ),
            child: data['online'] == "Çevrimiçi"
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.circle, color: Colors.green, size: 14),
                  )
                : Align(
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.circle, color: Colors.red, size: 14),
                  ),
            radius: 30,
            backgroundColor: Colors.white),
        title: Row(
          children: [
            Text(
              data['name'],
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              data['surName'],
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        subtitle: Text(
          data['mail'],
        ),
        onTap: () {
          String fullName = data['name'] + " " + data['surName'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                online: data['online'],
                receiverUserID: data['uid'],
                receiverName: fullName,
                userMail: data['mail'],
                receiverEmail: auth!.email!,
                senderName: auth!.displayName!,
                senderUserID: auth!.uid,
                image: data['image'],
              ),
            ),
          );
        },
      );
    }
    return Container();
  }
}
