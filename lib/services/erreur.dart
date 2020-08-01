import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Erreur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children : <Widget>[
               SpinKitFadingCircle(
                         color: Colors.red,
                         size: 100.0,
               ),
               Text("Un problème est apparu lors de l'inscription" , style: TextStyle(color:Colors.red, fontSize: 13,decoration: TextDecoration.none)),
               Text(" Veuillez quitter l'application et réessayer plus tard",style: TextStyle(color:Colors.red, fontSize: 13,decoration: TextDecoration.none)),
               SizedBox(height : 20),
               Text(" Remarque : Si vous n'arrivez pas à vous ",style: TextStyle(color:Colors.blue, fontSize: 13,decoration: TextDecoration.none)),
               Text("inscrire veuillez nous contacter sur cette adresse mail : ",style: TextStyle(color:Colors.blue, fontSize: 13,decoration: TextDecoration.none)),
               SizedBox(height : 10),
               Text("walid_hichem_ESE@hotmail.fr",style: TextStyle(color:Colors.green, fontSize: 13,decoration: TextDecoration.none)),
             ]
           ),
    );
  }
}