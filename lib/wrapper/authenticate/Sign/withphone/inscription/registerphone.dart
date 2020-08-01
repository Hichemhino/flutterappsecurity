import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcarsecur/services/auth.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withphone/inscription/suivant.dart';
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

class Phone extends StatefulWidget {
  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  TextEditingController _numerodephone = TextEditingController();
  //TextEditingController _password = TextEditingController();

  final _phoneRegex = RegExp(r"^(\+213)(5|6|7)[0-9]{8}$");
  //final _chassiRegex = RegExp(r"^[0-9.a-zA-Z]+");
  //final _caractRegex = RegExp(r"[!#$%&:,§'*+-/=?^_`{|}~]");

  final _formKey = GlobalKey<FormState>();

  final Services _auth = Services();
 // final FirebaseAuth _autfire = FirebaseAuth.instance;
  //final FirebaseDatabase _database = FirebaseDatabase.instance; 
  bool passwordhiden = true;
  bool loading = true;
  String erreur = '';
  String text = '';
  String verificationid,sms;
  String user;
  final _firestore = Firestore.instance;
  
  @override
  Widget build(BuildContext context) {
    
        return (!loading) ? Load(message: "l'opération peut prendre jusqu'a 3 minutes",) :  Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: RichText(
                text: TextSpan(
                    children: [
                        TextSpan(text: "Inscription Avec Telephone",style: TextStyle( fontSize: 20 )),
                      //  WidgetSpan(child: Icon(Icons.phone, size: 20),),
                      ],
                ),
              ),
              backgroundColor: Colors.green[400], 
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top :90.0, left: 8, right: 8),
              child: Form(
                 key: _formKey,
                  child: Column(
                    children : <Widget>[
                      // numéro de telephone
                          Text("* le numéro de téléphone doit commencer par l'indicatif +213.",style: TextStyle(color: Colors.blueAccent),),
                          TextFormField(
                            maxLength: 13,
                            decoration: InputDecoration(hintText: "Votre numéro de téléphone"),
                            controller: _numerodephone,
                            validator: (val) => (_phoneRegex.hasMatch(val)) ? null : "numéro de telephone incorrecte",
                          ),
                          SizedBox(height: 10),
                          RaisedButton(
                        color: Colors.lightGreen[400],
                        child: Text("Suivant"), onPressed: () async {
                        if(_formKey.currentState.validate()){
                          await (Connectivity().checkConnectivity()).then((connectivityResult) async{
                            if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
                             setState(() {
                               loading = false;
                               erreur = '';
                            });
                            // modification ici 26/07
                                final key = encrypt.Key.fromLength(32);
                                final iv = encrypt.IV.fromLength(8);
                                final encrypter =  encrypt.Encrypter(encrypt.Salsa20(key));
                                var cryptedPhone = encrypter.encrypt(_numerodephone.text, iv: iv).base64;
                            //await _firestore.collection("user").document("RZkExTxMen6Ja86TRBfL").get().then((query)async {
                           await FirebaseDatabase.instance.reference().child("users").once().then((DataSnapshot snapshot) async{ 
                                // Map<dynamic, dynamic> values = query.data;
                                 Map<dynamic, dynamic> values = snapshot.value;
                            if(!values.containsKey(cryptedPhone)){       
                               // if(!values.containsKey(_numerodephone.text)){
                                   await _auth.registerwithphone(_numerodephone.text,verificationid,sms).then((valeur) async{
                                  Future.delayed(const Duration(minutes: 3), () async{  
                                  Navigator.of(context).popUntil((route) => route.isFirst);   
                                  Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => Suivant(numphone: _numerodephone.text)));
                                });
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
            ),
      ),
    );
  }
}

