import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterappcarsecur/services/auth.dart';
import 'package:flutterappcarsecur/services/local_notification.dart';
import 'package:flutterappcarsecur/wrapper/wrapper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(
      MaterialApp(home: Suite()),
    );

class Suite extends StatefulWidget {
  final String num;
  Suite({this.num});
  _SuiteState createState() => _SuiteState();
}

class _SuiteState extends State<Suite> {
  int etatled;
  bool open = true;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Services _auth = Services();
  Map etatDuSystem = Map();
  String numchassi;

  @override
  Widget build(BuildContext context) {
    if (widget.num != null) {
      numchassi = widget.num;
    }
    final databaseLED = FirebaseDatabase.instance.reference();
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Page Principale", style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
        backgroundColor: Colors.green[900],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            label: Text(
              'déconnecter',
              style: TextStyle(color: Colors.white, letterSpacing: 1.0),
            ),
            onPressed: () async {
              dynamic result = _auth.singOutAccount();
              if (result != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Wrapper()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              /*indication sur les indicateurs */
              /* light */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Éclairage :"),
                  RaisedButton(
                    onPressed: () async {
                      await _database
                          .reference()
                          .child("input_output")
                          .child(numchassi)
                          .update({
                        "state_parking_light": 2,
                      });
                    },
                    child: Text("Allumer"),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await _database
                          .reference()
                          .child("input_output")
                          .child(numchassi)
                          .update({
                        "state_parking_light": -1,
                      });
                    },
                    child: Text("Éteindre"),
                  ),
                  StreamBuilder(
                    stream: databaseLED
                        .child("input_output")
                        .child(numchassi)
                        .onValue,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "wait!",
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          snapshot.error,
                        );
                      } else if (snapshot.hasData) {
                        etatDuSystem = snapshot.data.snapshot.value;
                        if (etatDuSystem["state_parking_light"] == 1)
                          return Icon(Icons.brightness_1, color: Colors.green);
                        else if (etatDuSystem["state_parking_light"] == 0)
                          return Icon(Icons.brightness_1, color: Colors.red);
                        else
                          return CircularProgressIndicator();
                      } else {
                        return Text('null data!');
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              /* Climat */
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Climatiseur :"),
                    RaisedButton(
                      onPressed: () async {
                        await _database
                            .reference()
                            .child("input_output")
                            .child(numchassi)
                            .update({
                          "state_clima": 2,
                        });
                      },
                      child: Text("Allumer"),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        await _database
                            .reference()
                            .child("input_output")
                            .child(numchassi)
                            .update({
                          "state_clima": -1,
                        });
                      },
                      child: Text("Éteindre"),
                    ),
                    StreamBuilder(
                      stream: databaseLED
                          .child("input_output")
                          .child(numchassi)
                          .onValue,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            "wait!",
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            snapshot.error,
                          );
                        } else if (snapshot.hasData) {
                          etatDuSystem = snapshot.data.snapshot.value;
                          if (etatDuSystem["state_clima"] == 1)
                            return Icon(Icons.brightness_1,
                                color: Colors.green);
                          else if (etatDuSystem["state_clima"] == 0)
                            return Icon(Icons.brightness_1, color: Colors.red);
                          else
                            return CircularProgressIndicator();
                        } else {
                          return Text('null data!');
                        }
                      },
                    ),
                  ]),
              SizedBox(height: 10),
              /* Window */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Fenêtres :"),
                  RaisedButton(
                    child: Text("Monter"),
                    onPressed: () async {
                      await _database
                          .reference()
                          .child("input_output")
                          .child(numchassi)
                          .update({
                        "state_window": 2,
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Descendre"),
                    onPressed: () async {
                      await _database
                          .reference()
                          .child("input_output")
                          .child(numchassi)
                          .update({
                        "state_window": -1,
                      });
                    },
                  ),
                  StreamBuilder(
                    stream: databaseLED
                        .child("input_output")
                        .child(numchassi)
                        .onValue,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "wait!",
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          snapshot.error,
                        );
                      } else if (snapshot.hasData) {
                        etatDuSystem = snapshot.data.snapshot.value;
                        if (etatDuSystem["state_window"] == 1)
                          return Icon(Icons.brightness_1, color: Colors.green);
                        else if (etatDuSystem["state_window"] == 0)
                          return Icon(Icons.brightness_1, color: Colors.red);
                        else
                          return CircularProgressIndicator();
                      } else {
                        return Text('null data!');
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              /* Door lock */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Portes :"),
                  RaisedButton(
                    child: Text("Vérouiller"),
                    onPressed: () async {
                      await _database
                          .reference()
                          .child("input_output")
                          .child(numchassi)
                          .update({
                        "state_door_lock": 2,
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Déverouiller"),
                    onPressed: () async {
                      await _database
                          .reference()
                          .child("input_output")
                          .child(numchassi)
                          .update({
                        "state_door_lock": -1,
                      });
                    },
                  ),
                  StreamBuilder(
                    stream: databaseLED
                        .child("input_output")
                        .child(numchassi)
                        .onValue,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "wait!",
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          snapshot.error,
                        );
                      } else if (snapshot.hasData) {
                        etatDuSystem = snapshot.data.snapshot.value;
                        if (etatDuSystem["state_door_lock"] == 1)
                          return Icon(Icons.brightness_1, color: Colors.green);
                        else if (etatDuSystem["state_door_lock"] == 0)
                          return Icon(Icons.brightness_1, color: Colors.red);
                        else
                          return CircularProgressIndicator();
                      } else {
                        return Text('null data!');
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              /*siren */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Alarme :"),
                  RaisedButton(
                    child: Text("Activer"),
                    onPressed: () async {
                      await _database
                          .reference()
                          .child("input_output")
                          .child(numchassi)
                          .update({
                        "state_alarme": 2,
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Désactiver"),
                    onPressed: () async {
                      await _database
                          .reference()
                          .child("input_output")
                          .child(numchassi)
                          .update({
                        "state_alarme": -1,
                      });
                    },
                  ),
                  StreamBuilder(
                    stream: databaseLED
                        .child("input_output")
                        .child(numchassi)
                        .onValue,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "wait!",
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          snapshot.error,
                        );
                      } else if (snapshot.hasData) {
                        etatDuSystem = snapshot.data.snapshot.value;
                        if (etatDuSystem["state_alarme"] == 1) {
                          return Icon(Icons.brightness_1, color: Colors.green);
                        } else if (etatDuSystem["state_alarme"] == 0)
                          return Icon(Icons.brightness_1, color: Colors.red);
                        else
                          return CircularProgressIndicator();
                      } else {
                        return Text('null data!');
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              /*car starter */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Starter :"),
                  RaisedButton(
                    child: Text("Démarrer"),
                    onPressed: () async {
                      await _database
                          .reference()
                          .child("input_output")
                          .child(numchassi)
                          .update({
                        "state_car_starter": 2,
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Arrêter"),
                    onPressed: () async {
                      await _database
                          .reference()
                          .child("input_output")
                          .child(numchassi)
                          .update({
                        "state_car_starter": -1,
                      });
                    },
                  ),
                  StreamBuilder(
                    stream: databaseLED
                        .child("input_output")
                        .child(numchassi)
                        .onValue,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "wait!",
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          snapshot.error,
                        );
                      } else if (snapshot.hasData) {
                        etatDuSystem = snapshot.data.snapshot.value;
                        if (etatDuSystem["state_car_starter"] == 1)
                          return Icon(Icons.brightness_1, color: Colors.green);
                        else if (etatDuSystem["state_car_starter"] == 0)
                          return Icon(Icons.brightness_1, color: Colors.red);
                        else
                          return CircularProgressIndicator();
                      } else {
                        return Text('null data!');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
