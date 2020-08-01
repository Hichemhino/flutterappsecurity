import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withemail/connexion/signemail.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withphone/connexion/signphone.dart';
import 'package:flutterappcarsecur/wrapper/load/load.dart';
import 'package:encrypt/encrypt.dart' as  encrypt;


Future<String> synchronisation() async{
  try {
    return((await FirebaseAuth.instance.currentUser()).uid);
  } catch (e) {
    print(e.toString());
    return(null);
  }
 }

class Passwords extends StatefulWidget {
  @override
  _PasswordsState createState() => _PasswordsState();
  final String numphone;
  Passwords({this.numphone});
}

class _PasswordsState extends State<Passwords> {
  String numphone = "+213790699084";
  String erreur = '';
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
  bool passwordhiden = true;
  bool loading = true;
  TextEditingController _password = TextEditingController();
  TextEditingController _code = TextEditingController();
  final FirebaseDatabase _database = FirebaseDatabase.instance; 
  String text = '';
  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) { 
   /* if(widget.numphone != null){
      setState(() {
        numphone = widget.numphone;
      });
    }  */       
    return (!loading) ? Load() :
             Scaffold(
               appBar:AppBar(
            centerTitle: true,
            title: RichText(
                text: TextSpan(
                    children: [
                        TextSpan(text: "Créer un mot de passe",style: TextStyle( fontSize: 20 )),
                      //  WidgetSpan(child: Icon(Icons.phone, size: 20),),
                      ],
                ),
              ),
              backgroundColor: Colors.green[400], 
              ), 
                 body: SingleChildScrollView(
                                    child: Padding(
                   padding: const EdgeInsets.only(top :90.0, left: 8, right: 8),
                   child: Center(
                     child: new Form(
                       key: _formKey,
                      child: Column(
                        children : <Widget>[
                                  // mot de passe
                                   TextFormField(
                                    validator: (val) => val.length >= 6 ? null : 'mot de passe non valide' ,
                                    controller: _password,
                                    obscureText: passwordhiden,
                                    decoration: InputDecoration(hintText: "Veuillez introduire votre Mot de passe",
                                    suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), 
                                     onPressed:()   {
                                       setState(() {
                                      passwordhiden = !passwordhiden;
                                      });
                                     }                      
                                   ),
                                   ),
                                  ),
                               Text("* ce code est utilisé afin de modifier votre mot de passe", style: TextStyle(color: Colors.blue,)),
                               TextFormField(
                                decoration: InputDecoration(hintText: "Votre code secret"),
                                controller: _code,
                                validator: (val) => (val.isEmpty) ? 'code non valide' : null ,
                              ),
                             RaisedButton(
                                color: Colors.lightGreen[400],
                                child: Text("enregistrer"), onPressed: () async {
                                if(_formKey.currentState.validate()){
                                  await (Connectivity().checkConnectivity()).then((connectivityResult) async{
                                    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
                                     setState(() {
                                       loading = false;
                                       erreur = '';
                                    });
                                        final key = encrypt.Key.fromLength(32);
                                        final iv = encrypt.IV.fromLength(8);
                                        final encrypter =  encrypt.Encrypter(encrypt.Salsa20(key));
                                        var motdepasse = encrypter.encrypt(_password.text, iv: iv);
                                        var codesecret = encrypter.encrypt(_code.text, iv: iv);
                                        var cryptednumphone = encrypter.encrypt(numphone, iv: iv).base64;
                                    await _database.reference().child("all_user").child(numphone).once().then((DataSnapshot snapshot)async{
                                     await _database.reference().child("input_output").child(snapshot.value).update({
                                        "state_parking_light":-1,
                                        "state_window":-1,
                                        "state_door_lock":-1,
                                        "state_clima":-1,
                                        "state_car_starter":-1,
                                        "state_alarme" : -1,
                                        "verif_firebase" : true,
                                      }).then((value) async{
                                        await _database.reference().child("userphone_passwords").update({
                                          numphone: motdepasse.base64+"//"+codesecret.base64,
                                        }).then((value) async{ 
                                           await _database.reference().child("users").update({
                                             cryptednumphone : cryptednumphone
                                              }).then((value){
                                            setState(() {
                                              loading = true;
                                              erreur = '';
                                              });
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                        Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => Signphone(sms: 'inscription réussite')));

                                              });


                                           
                                        });
                                      });


                                    });
                                    } // pas de touche
                                    else{
                                        setState(() {
                                          erreur = 'pas de connexion internet';
                                        });
                                        
                                    }
                                  }
                                  );
                                 }
                                }
                              ),
                              Text(erreur,style: TextStyle(color: Colors.red),),Text(erreur,)
                        ]
                      )
            ),
                   ),
               ),
                 ),
             );
            }
       }