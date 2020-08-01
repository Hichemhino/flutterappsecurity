import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcarsecur/services/auth.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withemail/connexion/signemail.dart';
import 'package:flutterappcarsecur/wrapper/load/load.dart';
import 'package:encrypt/encrypt.dart' as  encrypt;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
    // RegExp
    final _emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+");
    ///final _chassiRegex = RegExp(r"^[0-9.a-zA-Z]+");
    //final _caractRegex = RegExp(r"[!#$%&:,§'*+-/=?^_`{|}~]");
    //// controlle
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
   // TextEditingController _numeroduchassi = TextEditingController();
    // firebase
    final FirebaseDatabase _database = FirebaseDatabase.instance; 
    // autre variable
    final Services _auth = Services();
    final _formKey = GlobalKey<FormState>();
    bool loading = true;
    String erreur = '';
    bool passwordhide = true;
  @override
  Widget build(BuildContext context) {
    return  !loading ?  Load() :    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],            
        centerTitle: true,
            title: RichText(
                text: TextSpan(
                    children: [
                        TextSpan(text: "Inscription Avec email",style: TextStyle( fontSize: 20 )),
                       // WidgetSpan(child: Icon(Icons.email , size: 20),),
                      ],
                ),
              ),
      ),
      body: 
      SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top :90.0, left: 8, right: 8),
                child: Column(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      // email
                      TextFormField(
                        decoration: InputDecoration(hintText: "Email"),
                        controller: _email,
                        validator : (value) => _emailRegex.hasMatch(value) ?  null : "email non valide" ,
                      ),
                      SizedBox(height: 10),
                      // mot de passe
                      TextFormField(
                        decoration: InputDecoration(hintText: "mot de passe",
                        suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), 
                        onPressed:()   {
                          setState(() {
                            passwordhide = !passwordhide;
                          });
                         }                      
                        ),
                        
                        ),
                        controller: _password,
                        obscureText:passwordhide,
                        validator: (val) => val.length <= 6 ? 'mot de passe ' : null,
                      ),
                      SizedBox(height: 10),
                      // numero de chassi
                     /* TextFormField(
                        validator: (val) => (val.contains(_chassiRegex) && !val.contains(_caractRegex)) ? null : "erreur dans le numero de chassis",
                        decoration: InputDecoration(hintText: "numero de chassis de votre vehicule"),
                        controller: _numeroduchassi,
                      ),*/
                      SizedBox(height: 10),
                     // boutton
                      RaisedButton(
                        color: Colors.lightGreen[400],
                        child: Text("Enregistrer"), onPressed: () async {
                        if(_formKey.currentState.validate()){
                          await (Connectivity().checkConnectivity()).then((connectivityResult) async{
                            if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
                             setState(() {
                               loading = false;
                               erreur = '';
                            });
                             // modification ici le 26/07
                             //await _firestore.collection("user").document("RZkExTxMen6Ja86TRBfL").get().then((query)async {});
                                    final key = encrypt.Key.fromLength(32);
                                    final iv = encrypt.IV.fromLength(8);
                                    final encrypter =  encrypt.Encrypter(encrypt.Salsa20(key));
                                    var cryptedMail = encrypter.encrypt(_email.text, iv: iv).base64;
                           await FirebaseDatabase.instance.reference().child("users").once().then((DataSnapshot snapshot) async{           
                                Map<dynamic, dynamic> values = snapshot.value;
                            if(!values.containsKey(cryptedMail)){
                              await _auth.registerwithemailandpassword(_email.text,_password.text).then((value) async{
                              if(value != null){
                               await _database.reference().child("input_output").child(value).update({
                                "state_parking_light":-1,
                                "state_window":-1,
                                "state_door_lock":-1,
                                "state_clima":-1,
                                "state_car_starter":-1,
                                "state_alarme" : -1,
                                "verif_firebase" : true,
                              }).then((valeur) async{
                                await _database.reference().child("all_user").update({
                                  _email.text.replaceAll(".","%") : value,
                                }).then((value) async{
                                  await _database.reference().child("users").update({
                                    cryptedMail : cryptedMail
                                  }).then((value){
                                  setState(() {
                                   loading = true;
                                   erreur = '';
                                  });
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                Navigator.of(context).pushReplacement(
                                 MaterialPageRoute(builder: (context) => Sign(num: "Inscription réussite")));

                                  });
                                });
                              });
                            }
                          });
                        }
                                 else{
                                   setState(() {
                                     loading = true;
                                     erreur = 'compte déja existant';
                                   });
                                 }
                                 });
                            }
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
                      Text(erreur, style:  TextStyle(color: Colors.red)),
                    ]
                ),
            ),

          ],
        ),
              ),
      ),

    );
  }
}




                       /* */