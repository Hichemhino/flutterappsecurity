import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withphone/inscription/password_for_phone.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withphone/inscription/registerphone.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withphone/motdepasse/test.dart';
import 'package:flutterappcarsecur/wrapper/home/page2.dart';
import 'package:flutterappcarsecur/wrapper/load/load.dart';
import 'package:encrypt/encrypt.dart' as  encrypt;

Future registerwithphone(String phone, String verificationid,String sms,String user) async{
        final FirebaseAuth _auth = FirebaseAuth.instance;
        TextEditingController code = TextEditingController();
        FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 120), 
      verificationCompleted: (AuthCredential credential) async{
       await _auth.signInWithCredential(credential).then((AuthResult result) async{
       });
      },
      verificationFailed: (AuthException exception){
       print("==> ${exception.message}");
     },
      codeSent: (String verification,[int renvoyerlecode]){
       verificationid = verification;
       BuildContext context;
        showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context){
                return AlertDialog(
                  backgroundColor: Colors.green,
                  content: 
                    TextField(
                        decoration: InputDecoration(hintText:"veuillez saisir votre code"),
                        maxLength: 6,
                        controller: code,
                      ),
                    actions: <Widget>[
                      RaisedButton(
                        child:Text("envoyer"),
                        onPressed: () async{
                           AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationid, smsCode: code.text);
                           await _auth.signInWithCredential(credential).then((AuthResult resultat) async{
                               Navigator.of(context).pop();
                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Passwords(numphone: phone)));
                           });
                            }),
                    ],
                );
              }
            );
     },
      codeAutoRetrievalTimeout: (String id){
       verificationid = id;}
     // codeAutoRetrievalTimeout: null,
      );
}

class Signphone extends StatefulWidget {
  @override
  _SignphoneState createState() => _SignphoneState();
  final String sms;
  Signphone({this.sms});
}

class _SignphoneState extends State<Signphone> {
  TextEditingController _numerodephone = TextEditingController();
  TextEditingController _password = TextEditingController();

  final _phoneRegex = RegExp(r"^(\+213)(5|6|7)[0-9]{8}$");
  final _formKey = GlobalKey<FormState>();
  final FirebaseDatabase _database = FirebaseDatabase.instance; 
  bool passwordhiden = true;
  String message = '';
  final _firestore = Firestore.instance;
  bool loading = true;
  String erreur = '';
  String uidpassword,numphone,verificationid,sms,user;
  String text = '';
  @override
  Widget build(BuildContext context) {
    if (widget.sms != null){
    setState(() {
       message = widget.sms;
    });
  }
    return (!loading) ? Load() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
            title: RichText(
                text: TextSpan(
                    children: [
                        TextSpan(text: "Connexion Avec Telephone",style: TextStyle( fontSize: 20 )),
                      ],
                ),
              ),
        //centerTitle: true,
      ),
      body: 
      SingleChildScrollView(
              child: Padding(
          padding: const EdgeInsets.only(top :90.0, left: 8, right: 8),
          child: Center(
            child : Form(
              key: _formKey,
              child: Column(
                children : <Widget>[
                           // numero de phone
                            TextFormField(
                              maxLength: 13,
                              decoration: InputDecoration(hintText: "Introduire votre Numéro de téléphone"),
                              controller: _numerodephone,
                              validator: (val) => (_phoneRegex.hasMatch(val)) ? null : "numéro de telephone incorrecte",
                            ),
                            SizedBox(height: 10),
                          // mot de passe
                           TextFormField(
                            validator: (val) => val.length >= 6 ? null : 'mot de passe non valide' ,
                            controller: _password,
                            obscureText: passwordhiden,
                            decoration: InputDecoration(hintText: "Mot de passe",
                             suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), 
                             onPressed:(){
                               setState((){
                              passwordhiden = !passwordhiden;
                              });
                             }                      
                            ),
                           ),
                        ),
                        SizedBox(height: 10),
                        // boutton
                        RaisedButton(
                          color: Colors.lightGreen[400],
                          child: Text("connexion"), onPressed: () async {
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
                              var cryptedphone = encrypter.encrypt(_numerodephone.text, iv: iv).base64;
                            // await _firestore.collection("user").document("RZkExTxMen6Ja86TRBfL").get().then((query)async {
                            //   Map<dynamic, dynamic> values = query.data;
                            //   if(values.containsKey(cryptedphone)){
                              await FirebaseDatabase.instance.reference().child("users").once().then((DataSnapshot snapshot)async{
                                   Map<dynamic, dynamic> phone = snapshot.value;
                            if(phone.containsKey(cryptedphone)){
                              await registerwithphone(_numerodephone.text,verificationid, sms, user).then((onValue) async{
                                Future.delayed(const Duration(seconds: 50), () async { 
                                  DatabaseReference _ref = _database.reference();
                                      await  _ref.child("userphone_passwords").child(_numerodephone.text
                                      ).once().then((DataSnapshot snapshot) async{
                                            uidpassword = await snapshot.value;  
                                      }).then((onValue) async{
                                    final key = encrypt.Key.fromLength(32);
                                    final iv = encrypt.IV.fromLength(8);
                                    final encrypter =  encrypt.Encrypter(encrypt.Salsa20(key));
                                        if (uidpassword.split("//")[0] == encrypter.encrypt(_password.text, iv: iv).base64) {
                                          _ref.child("all_user").child(_numerodephone.text).once().then((DataSnapshot snapshot) async{
                                             String uid = await snapshot.value; // c'est pas grave si j'ècrase la valeur.
                                          setState(() {
                                            loading = true;
                                            erreur = '';
                                        });
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Suite(num: uid)));
                                          });
                                           }  
                                           else{
                                              setState(() {
                                                loading = true;
                                                erreur = 'mot de passe ou numéro de telephone incorrecte';
                                          }); 
                              }
                                      });                                 

                                });

                              });
                             }
                             else{
                               setState((){
                                 loading = true;
                                 erreur = 'compte inexistant';
                              });

                              }
                              });

                             }
                            else{
                                  setState(() {
                                    erreur = 'pas de connexion internet';
                                  });
                                }
                              });
                            }
                        },
                        ),
                        Text(erreur,style: TextStyle(color:  Colors.red)),
                        Text(message, style: TextStyle(color: Colors.green)),
                    // mot de passe oublié
                        InkWell(
                   child: Text("mot de passe oublié ?" , style: TextStyle(color: Colors.grey[600],decoration: TextDecoration.underline),),
                   onTap:() {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Forget()),);
                   }
                  ),
                        SizedBox(height: 10.0),
                    // inscription
                        InkWell(
                      child: Text("Cliquez ici pour S'inscrire " , style: TextStyle(color: Colors.grey[600],decoration: TextDecoration.underline),),
                      onTap:()  {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Phone()),);
                        },
                    ),
                ]
              ) ,
              ),
          ),
        ),
      ),
    );
  }
}