import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcarsecur/services/erreur.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withphone/inscription/password_for_phone.dart';



Future<String> synchronisation() async{
  try {
    return((await FirebaseAuth.instance.currentUser()).uid);
  } catch (e) {
    print(e.toString());
    return(null);
  }
 }


class Suivant extends StatefulWidget {
  final String numphone;
  Suivant({this.numphone});
  @override
  _SuivantState createState() => _SuivantState();
}

class _SuivantState extends State<Suivant> {
  String numphone;
  @override
  Widget build(BuildContext context) {
    if(widget.numphone != null){
      numphone = widget.numphone;
    }
    return
    FutureBuilder(
     future: synchronisation(),
     builder:(context ,snapshot) {
          if(snapshot.hasData){
              return Passwords(numphone: numphone);
            }
          else{
              return Erreur();
          }
     }
     );
  }
}