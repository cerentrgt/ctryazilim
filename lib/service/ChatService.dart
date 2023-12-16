import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var firebaseStorage = FirebaseStorage.instance;
  Future<void> sendMessage(
    String receiverId,
    String message,
    String type,
    String senderName,
    String receiverName,
    String receiverEmail,
    String? docName,
  ) async {
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      docName,
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
      senderName: senderName,
      receiverEmail: receiverEmail,
      receiverName: receiverName,
      type: type,
    );

    List<String> ids = [currentUserId, receiverId];

    ids.sort();
    String chatRoomId = ids.join("_");
    await firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection(currentUserId)
        .add(newMessage.toMap());
    await firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection(receiverId)
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection(otherUserId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> remoweMessages(String userId, String otherUserId, String docId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    var ref = firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .doc(docId)
        .delete();

    return ref;
  }

  Future onImageButton(
      ImageSource source,
      BuildContext? context,
      String receiverUserID,
      String senderName,
      String receiverName,
      String receiverEmail,
      String senderUserID) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);

      //uploadMedia(imageTemporary);

      var uploadTask = firebaseStorage
          .ref()
          .child("User")
          .child("${image.name}.${imageTemporary.path.split('.').last}")
          .putFile(imageTemporary);

      uploadTask.snapshotEvents.listen((event) {});

      var storageRef = await uploadTask;
      var store = await storageRef.ref.getDownloadURL();
      String type = "img";
      sendMessage(receiverUserID, store, type, senderName, receiverName,
          receiverEmail, image.name);
      addChatYedek(receiverUserID, auth.currentUser!.uid, senderName, store,
          receiverName, DateTime.now().toString());

      return store;
    } catch (e) {
      print(e);
    }
  }

  void addUserIfNotExists(String userName, String userUid, String userMail,
      String userImage, String messages, String date, String online) async {
    var usersCollection = firestore
        .collection('chatUsers')
        .doc(auth.currentUser!.uid)
        .collection("chats");
    var usCollection =
        firestore.collection('chatUsers').doc(userUid).collection("chats");

    QuerySnapshot snapshot =
        await usersCollection.where('userUid', isEqualTo: userUid).get();

    if (snapshot.docs.isEmpty) {
      // Kullanıcı daha önce kaydedilmemiş, kaydet
      await usersCollection.add({
        'userName': userName,
        'userUid': userUid,
        'userMail': userMail,
        'userImage': userImage,
        'messages': messages,
        'date': date,
        'online': online
        // Diğer kullanıcı bilgileri
      });
      await usCollection.add({
        'userName': auth.currentUser!.displayName,
        'userUid': auth.currentUser!.uid,
        'userMail': auth.currentUser!.email,
        'userImage': auth.currentUser!.photoURL,
        'messages': messages,
        'date': date,
        'online': online
        // Diğer kullanıcı bilgileri
      });
    } else {
      // Kullanıcı zaten kaydedilmiş, güncelle
      DocumentSnapshot docSnapshot = snapshot.docs.first;
      String docId = docSnapshot.id;

      await usersCollection.doc(docId).update({
        // Güncellenecek alanlar
        'messages': messages,
        'date': date, 'online': online

        // ...
      });
    }
  }

  Stream<QuerySnapshot> getChatList() {
    var usersCollection = firestore
        .collection('chatUsers')
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .snapshots();
    return usersCollection;
  }

  Future<void> updateChatList(String docId, String messages, String date) {
    var usersCollection = firestore
        .collection('chatUsers')
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(docId)
        .update({
      'messages': messages,
      'date': date

      // ...
    });

    return usersCollection;
  }

  Future<void> remoweChatList(String docId) async {
    var ref = await firestore
        .collection('chatUsers')
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(docId)
        .delete();

    return ref;
  }

  Future<void> remoweChats(String userId, String otherUserId) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    try {
      /*final subcollectionRef = firestore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages");
      final subcollectionSnapshot = await subcollectionRef.get();

      // Alt koleksiyon içindeki belgeleri silin
      final deleteFutures =
          subcollectionSnapshot.docs.map((doc) => doc.reference.delete());
      await Future.wait(deleteFutures);

      // Alt koleksiyonu silin
      await subcollectionRef.doc(chatRoomId).delete();

      print('Alt koleksiyon ve belgeler başarıyla silindi.');*/
      final user1MessagesRef = firestore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection(otherUserId);

      // Kullanıcının iletilerini silin
      await user1MessagesRef.get().then((snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (e) {
      print("Error deleting collection: $e");
    }
  }

  Future<void> updateChatUser(
      String userId, String otherUserId, String docId) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Son dokümanı al
        DocumentSnapshot lastDocument = querySnapshot.docs.first;
        var lastMessageData = lastDocument.data() as Map<String, dynamic>;

        // lastMessageData içindeki messages alanına erişin
        var messages = lastMessageData['message'];
        Timestamp t = lastMessageData['timestamp'] as Timestamp;
        DateTime date = t.toDate();
        String dates =
            "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

        var usersCollection = firestore
            .collection('chatUsers')
            .doc(auth.currentUser!.uid)
            .collection("chats");

        QuerySnapshot snapshot =
            await usersCollection.where('userUid', isEqualTo: userId).get();

        // Kullanıcı zaten kaydedilmiş, güncelle
        DocumentSnapshot docSnapshot = snapshot.docs.first;
        String docId = docSnapshot.id;

        updateChatList(docId, messages, dates);
        // messages alanını kullanabilirsiniz
        print('Son Mesajın Messages Alanı: $messages');
      } else {
        print('Koleksiyon Boş veya Doküman Bulunamadı');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addChatYedek(
      String receiverUserID,
      String userUid,
      String senderName,
      String messages,
      String receiverName,
      String dates) async {
    print("çalştır");
    FirebaseFirestore.instance
        .collection('chatUsersYedek')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .add({
      'receiverUserID': receiverUserID,
      'userUid': userUid,
      'senderName': senderName,
      'messages': messages,
      'receiverName': receiverName,
      'date': dates,
      // Diğer kullanıcı bilgileri
    });
  }
}
