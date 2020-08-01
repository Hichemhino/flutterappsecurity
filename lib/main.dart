import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcarsecur/services/local_notification.dart';

import 'package:flutterappcarsecur/wrapper/home/page2.dart';
import 'package:flutterappcarsecur/wrapper/wrapper.dart';
import 'package:get_it/get_it.dart';

Future<String> synchronisation() async {
  try {
    return ((await FirebaseAuth.instance.currentUser()).uid);
  } catch (e) {
    print(e.toString());
    return (null);
  }
}
final getIt = GetIt.instance;
final PushNotificationsManager notification = PushNotificationsManager();
void main() => runApp(
      getIt.registerSingleton<PushNotificationsManager>(PushNotificationsManager());
      
      MaterialApp(home: Home()),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //final PushNotificationsManager _notification = PushNotificationsManager();
  
  
  @override
  Widget build(BuildContext context) {
    return (FutureBuilder(
        future: synchronisation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Suite(num: snapshot.data);
          } else {
            return Wrapper();
          }
        }));
  }
}
