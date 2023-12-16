import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final FlutterLocalNotificationsPlugin localNoti =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings androidsettings =
      AndroidInitializationSettings('flutter_logo');

  void initialiseNotifications() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidsettings);

    await localNoti.initialize(initializationSettings);
  }

  void sendNotifiation(String title, String body) async {
    print("noti calıstı");
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await localNoti.show(0, title, body, notificationDetails);
  }
}
