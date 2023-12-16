import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kapsul_teknoloji/screens/ChatPage/ImagePage.dart';
import 'package:kapsul_teknoloji/service/ChatService.dart';
import 'package:kapsul_teknoloji/service/UserService.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/NotiService.dart';
import '../Profil/ProfilUserScreen.dart';

class ChatPage extends StatefulWidget {
  final String userMail;
  final String senderName;
  final String receiverName;
  final String receiverEmail;
  final String receiverUserID;
  final String senderUserID;
  final String image;
  final String online;

  const ChatPage({
    super.key,
    required this.receiverUserID,
    required this.senderUserID,
    required this.image,
    required this.userMail,
    required this.senderName,
    required this.receiverName,
    required this.receiverEmail,
    required this.online,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var messages = TextEditingController();
  var firebaseStorage = FirebaseStorage.instance;
  ChatService chatService = ChatService();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var userService = UserService();
  late ScrollController scrollController;
  String online = "Çevrimiçi";
  String? dates;
  String? dateTime;

  final userUid = FirebaseAuth.instance.currentUser!.uid;
  var notiService = NotiService();

  @override
  void initState() {
    notiService.initialiseNotifications();
    scrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0d0b28),
      appBar: AppBar(
        backgroundColor: Color(0xff0d0b28),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.image,
              ),
              radius: 25,
              backgroundColor: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilUserScreen(
                        userUid: widget.receiverUserID,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiverName),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.online,
                  style: TextStyle(
                      fontSize: 12,
                      color: widget.online == "Çevrimdışı"
                          ? Color.fromARGB(255, 240, 85, 74)
                          : Color.fromARGB(255, 94, 243, 99)),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(children: [
        Expanded(
          child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: buildMessageList()),
        ),
        buildMessageInput(),
      ]),
    );
  }

  Widget buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessages(
          widget.receiverUserID, firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Yükleniyor");
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });

        return ListView(
          padding: EdgeInsets.only(top: 15.0),
          controller: scrollController,
          children: snapshot.data!.docs
              .map<Widget>((e) => buildMessageItem(e))
              .toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    Timestamp t = data['timestamp'] as Timestamp;
    DateTime date = t.toDate();
    dates =
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    dateTime =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    var alignment = (data['senderId'] == firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    var margin = (data['senderId'] == firebaseAuth.currentUser!.uid)
        ? EdgeInsets.only(top: 8, bottom: 8, left: 80)
        : EdgeInsets.only(top: 8, bottom: 8, right: 80);

    var padding = EdgeInsets.symmetric(horizontal: 25, vertical: 10);

    var decoration = BoxDecoration(
        color: Color.fromARGB(255, 212, 228, 241),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
            topRight: Radius.circular(15)));
    if (data['type'] == "text") {
      return Container(
        padding: padding,
        margin: margin,
        decoration: decoration,
        alignment: alignment,
        child: Column(
            crossAxisAlignment:
                (data['senderId'] == firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == firebaseAuth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 212, 228, 241),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  showAlertDialog(doc.id);
                },
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dates!,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            dateTime!,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        data['message'],
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      );
    } else if (data['type'] == "img") {
      return Container(
        padding: padding,
        margin: (data['senderId'] == firebaseAuth.currentUser!.uid)
            ? EdgeInsets.only(top: 8, bottom: 8, left: 200)
            : EdgeInsets.only(top: 8, bottom: 8, right: 200),
        decoration: decoration,
        alignment: alignment,
        child: Column(
            crossAxisAlignment:
                (data['senderId'] == firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == firebaseAuth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              data['message'] != null
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 212, 228, 241),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          fixedSize: Size(150, 150)),
                      onLongPress: () {
                        showAlertDialog(doc.id);
                      },
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImagePage(
                              imageName: data['message'],
                              userName: data['docName'],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dates!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow
                                      .ellipsis, // Taşıma durumunda metni kırp
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                dateTime!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: 120,
                            height: 120,
                            alignment: Alignment.center,
                            child: Image.network(
                              data['message'],
                              fit: BoxFit.cover,
                              width: 120, // Genişlik sınırlaması
                              height: 120, // Yükseklik sınırlaması
                            ),
                          ),
                        ],
                      ),
                    )
                  : CircularProgressIndicator(),
            ]),
      );
    } else if (data['type'] == "url") {
      return Container(
        padding: padding,
        margin: margin,
        decoration: decoration,
        alignment: alignment,
        child: Column(
            crossAxisAlignment:
                (data['senderId'] == firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == firebaseAuth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              data['message'] != null
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 212, 228, 241),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        _launchUrl(data['message']);
                      },
                      onLongPress: () {
                        showAlertDialog(doc.id);
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dates!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow
                                      .ellipsis, // Taşıma durumunda metni kırp
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                dateTime!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            data['message'],
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ))
                  : CircularProgressIndicator(),
            ]),
      );
    } else {
      return Container(
        padding: padding,
        margin: margin,
        decoration: decoration,
        alignment: alignment,
        child: Column(
            crossAxisAlignment:
                (data['senderId'] == firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == firebaseAuth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              data['message'] != null
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 212, 228, 241),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        _launchUrl(data['message']);
                      },
                      onLongPress: () {
                        showAlertDialog(doc.id);
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dates!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow
                                      .ellipsis, // Taşıma durumunda metni kırp
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                dateTime!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  data['docName'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.downloading_outlined,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : CircularProgressIndicator(),
            ]),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Url bulunamadı";
    }
  }

  Widget buildMessageInput() {
    return Container(
      height: 70,
      color: Color.fromARGB(255, 212, 228, 241),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          pdfButton(),
          IconButton(
              icon: Icon(
                Icons.photo,
                color: Colors.red,
              ),
              onPressed: () {
                String online = "Yazıyor..";
                userService.updateUser(
                    FirebaseAuth.instance.currentUser!.uid, online);
                Fluttertoast.showToast(msg: "Görsel Gönderiliyor");
                chatService.onImageButton(
                  ImageSource.gallery,
                  context,
                  widget.receiverUserID,
                  widget.senderName,
                  widget.receiverName,
                  widget.userMail,
                  widget.senderUserID,
                );
              }),
          Expanded(
            child: TextField(
              controller: messages,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(
                hintText: 'Mesajınızı yazın..',
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 60, color: Colors.greenAccent),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              onChanged: (value) {
                String online = "Yazıyor..";
                userService.updateUser(
                    FirebaseAuth.instance.currentUser!.uid, online);
              },
            ),
          ),
          IconButton(
            iconSize: 25,
            onPressed: () {
              sendMessage();
              Fluttertoast.showToast(msg: "Mesaj gönderildi");
              String online = "Çevrimiçi";
              userService.updateUser(
                  FirebaseAuth.instance.currentUser!.uid, online);

              if (widget.receiverUserID == firebaseAuth.currentUser!.uid) {
                notiService.sendNotifiation(
                    "Yeni mesajınız var", "${widget.receiverName}");
                print("calıştı");
              }
            },
            icon: Icon(
              CupertinoIcons.paperplane_fill,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget pdfButton() {
    return IconButton(
        onPressed: () async {
          String online = "Yazıyor..";
          userService.updateUser(
              FirebaseAuth.instance.currentUser!.uid, online);
          Fluttertoast.showToast(msg: "Pdf gönderiliyor");
          _onPdfButton(context);
        },
        icon: Icon(
          CupertinoIcons.paperclip,
          color: Colors.red,
        ));
  }

  Future _onPdfButton(BuildContext? context) async {
    try {
      final path = await FlutterDocumentPicker.openDocument();

      File file = File(path!);
      var str = path.split("/");
      String fileName = str[str.length - 1];
      var str2 = str[str.length - 1].split(".");
      String fileNames = str2[0];
      String type = str2[str2.length - 1];

      print("Filee ${str[str.length - 1]}");

      var uploadTask = firebaseStorage
          .ref()
          .child("UserPdf")
          .child("${fileNames}.${file.path.split('.').last}")
          .putFile(file);

      uploadTask.snapshotEvents.listen((event) {});

      var storageRef = await uploadTask;
      var store = await storageRef.ref.getDownloadURL();

      chatService.sendMessage(
        widget.receiverUserID,
        store,
        type,
        widget.senderName,
        widget.receiverName,
        widget.userMail,
        fileName,
      );
      chatService.addChatYedek(
        widget.receiverUserID,
        userUid,
        widget.senderName,
        messages.text,
        widget.receiverName,
        dateTime!,
      );

      chatService.addUserIfNotExists(widget.receiverName, widget.receiverUserID,
          widget.userMail, widget.image, fileName, dates!, widget.online);
      return store;
    } catch (e) {}
  }

  void sendMessage() async {
    if (messages.text.isNotEmpty) {
      if (messages.text.contains('http')) {
        String type = "url";

        await chatService.sendMessage(
          widget.receiverUserID,
          messages.text,
          type,
          widget.senderName,
          widget.receiverName,
          widget.userMail,
          "",
        );
        print(widget.receiverUserID);

        chatService.addChatYedek(
          widget.receiverUserID,
          userUid,
          widget.senderName,
          messages.text,
          widget.receiverName,
          dateTime!,
        );
        chatService.addUserIfNotExists(
            widget.receiverName,
            widget.receiverUserID,
            widget.userMail,
            widget.image,
            messages.text,
            dates!,
            widget.online);
      } else {
        String type = "text";
        print(widget.receiverEmail);
        await chatService.sendMessage(
          widget.receiverUserID,
          messages.text,
          type,
          widget.senderName,
          widget.receiverName,
          widget.userMail,
          "",
        );
        chatService.addChatYedek(
          widget.receiverUserID,
          userUid,
          widget.senderName,
          messages.text,
          widget.receiverName,
          dateTime!,
        );

        chatService.addUserIfNotExists(
            widget.receiverName,
            widget.receiverUserID,
            widget.userMail,
            widget.image,
            messages.text,
            dates!,
            widget.online);
      }

      messages.clear();
    }
  }

  void showAlertDialog(String doc) {
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
                  chatService.remoweMessages(widget.receiverUserID,
                      firebaseAuth.currentUser!.uid, doc);
                  chatService.updateChatUser(widget.receiverUserID,
                      firebaseAuth.currentUser!.uid, doc);
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
  }
}
