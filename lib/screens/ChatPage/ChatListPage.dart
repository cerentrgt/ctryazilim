import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/UsersPage/UserPage.dart';
import 'package:kapsul_teknoloji/service/ChatService.dart';

import '../../service/UserService.dart';
import '../ButtonPage/ButtonHomePage.dart';
import 'ChatPage.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  var chatService = ChatService();
  var auth = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;
  var userService = UserService();
  String name = "";
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: isSearching ? _buildSearchField() : _buildAppBarTitle(),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                userService.updateUser(auth!.uid, "Çevrimdışı");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => ButtonHomePage()),
                  ),
                );
              }),
          actions: [
            isSearching
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                        name = "";
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  )
          ],
          backgroundColor: Color(0xff0d0b28),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserPage()));
          },
          child: Icon(Icons.supervised_user_circle_outlined),
          backgroundColor: Color(0xff0d0b28),
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          child: body(),
        ));
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          name = value;
          isSearching = value.isNotEmpty;
        });
      },
      decoration: InputDecoration(
        hintText: "Kullanıcı adı",
        filled: true, // Metin alanının dolu renkte görüntülenmesini sağlar
        fillColor: Colors.white,
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Text(
      "CHATS",
      style: TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  StreamBuilder body() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatService.getChatList(),
        builder: (context, snapshot) {
          userService.updateUser(auth!.uid, "Çevrimiçi");
          return !snapshot.hasData
              ? const CircularProgressIndicator(
                  color: Colors.indigo,
                )
              : snapshot.data == null
                  ? const CircularProgressIndicator(
                      color: Colors.indigo,
                    )
                  : ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      children: snapshot.data!.docs
                          .map<Widget>((e) => buildUserListItem(e))
                          .toList(),
                    );
        });
  }

  Widget buildUserListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    if (name.isEmpty) {
      return ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Colors.blue),
          borderRadius: BorderRadius.circular(50),
        ),
        leading: CircleAvatar(
            backgroundImage: NetworkImage(
              data['userImage'],
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
        title: Text(
          data['userName'],
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                data['messages'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Text(
              data['date'],
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                online: data['online'],
                receiverUserID: data['userUid'],
                receiverName: data['userName'],
                userMail: data['userMail'],
                receiverEmail: auth!.email!,
                senderName: auth!.displayName!,
                senderUserID: auth!.uid,
                image: data['userImage'],
              ),
            ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  actions: [
                    const SizedBox(width: 5),
                    ListTile(
                      title: Text(
                        "Vazgeç",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      trailing: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ListTile(
                      title: Text("Sil", style: TextStyle(color: Colors.red)),
                      onTap: () {
                        chatService.remoweChats(data['userUid'], auth!.uid);
                        chatService.remoweChatList(doc.id);
                        Navigator.pop(context, true);
                      },
                      trailing: const Icon(
                        Icons.delete,
                        size: 22,
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }
    if (data['userName']
        .toString()
        .toLowerCase()
        .contains(name.toLowerCase())) {
      return ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Colors.blue),
          borderRadius: BorderRadius.circular(50),
        ),
        leading: CircleAvatar(
            backgroundImage: NetworkImage(
              data['userImage'],
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
        title: Text(
          data['userName'],
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                data['messages'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(),
            Text(
              data['date'],
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                online: data['online'],
                receiverUserID: data['userUid'],
                receiverName: data['userName'],
                userMail: data['userMail'],
                receiverEmail: auth!.email!,
                senderName: auth!.displayName!,
                senderUserID: auth!.uid,
                image: data['userImage'],
              ),
            ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  actions: [
                    const SizedBox(width: 5),
                    ListTile(
                      title: Text(
                        "Vazgeç",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      trailing: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ListTile(
                      title: Text("Sil", style: TextStyle(color: Colors.red)),
                      onTap: () {
                        chatService.remoweChats(data['userUid'], auth!.uid);
                        chatService.remoweChatList(doc.id);
                        Navigator.pop(context, true);
                      },
                      trailing: const Icon(
                        Icons.delete,
                        size: 22,
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }
    return Container();
  }
}
