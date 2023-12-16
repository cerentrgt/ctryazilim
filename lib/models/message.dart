import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String receiverEmail;
  final String? docName;
  final String message;
  final String type;
  final Timestamp timestamp;

  Message(
    this.docName, {
    required this.senderId,
    required this.senderEmail,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
    required this.type,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'receiverEmail': receiverEmail,
      'receiverName': receiverName,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp,
      'type': type,
      'docName': docName,
      
    };
  }
}
