// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class Localnotification {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void initState() {
//     initState();
//     initializing();
//   }

//   void initializing() async {
//     AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('app_icon');
//     IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
//         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//     InitializationSettings initializationSettings = InitializationSettings(
//         androidInitializationSettings, iosInitializationSettings);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//   }

//   void showNotifications() async {
//     await notification();
//   }

//   Future<void> notification() async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             'Channel ID', 'Channel title', 'channel body',
//             priority: Priority.High,
//             importance: Importance.Max,
//             ticker: 'test');

//     IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

//     NotificationDetails notificationDetails =
//         NotificationDetails(androidNotificationDetails, iosNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'Hello there', 'please subscribe my channel', notificationDetails);
//   }

//   Future<void> notificationAfter() async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             'second channel ID', 'second Channel title', 'second channel body',
//             priority: Priority.High,
//             importance: Importance.Max,
//             ticker: 'test');
//     IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

//     NotificationDetails notificationDetails =
//         NotificationDetails(androidNotificationDetails, iosNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(0, 'Alerte',
//         'Votre Alarme est activer', notificationDetails);
//   }

//   Future onSelectNotification(String payLoad) {
//     if (payLoad != null) {
//       print(payLoad);
//     }

//     // we can set navigator to navigate another screen
//   }

//   Future onDidReceiveLocalNotification(
//       int id, String title, String body, String payload) async {
//     return CupertinoAlertDialog(
//       title: Text(title),
//       content: Text(body),
//       actions: <Widget>[
//         CupertinoDialogAction(
//             isDefaultAction: true,
//             onPressed: () {
//               print("");
//             },
//             child: Text("Okay")),
//       ],
//     );
//   }

// }

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsManager {
  final FirebaseMessaging fcm = FirebaseMessaging();
  void init(BuildContext context) {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}
