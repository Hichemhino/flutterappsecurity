import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withphone/motdepasse/forgetpassword.dart';
import 'package:flutterappcarsecur/wrapper/load/load.dart';

class Forget extends StatefulWidget {
  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  TextEditingController _numerodephone = TextEditingController();
   // TextEditingController _password = TextEditingController();

  final _phoneRegex = RegExp(r"^(\+213)(5|6|7)[0-9]{8}$");
  TextEditingController _codesecret = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FirebaseDatabase _database = FirebaseDatabase.instance; 
  String uid,erreur='',val;
  bool loading = true;
  bool passwordhiden = true;
  @override
  Widget build(BuildContext context) {
    return (!loading)? Load() : Scaffold(
      appBar: AppBar(
        title: Text("Initialiser votre mot de passe"),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30,left: 15, right: 15),
          child: Form(
             key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                              TextFormField(
                                maxLength: 13,
                                decoration: InputDecoration(hintText: "Introduire votre Numéro de téléphone"),
                                controller: _numerodephone,
                                validator: (val) => (_phoneRegex.hasMatch(val)) ? null : "numéro doit commencer par +213",
                              ),
                              SizedBox(height: 10),
                            TextFormField(
                                validator: (val) => val.length >= 6 ? null : 'invalide au moin 6 caractere' ,
                                controller: _codesecret,
                                decoration: InputDecoration(hintText: "Veuillez introduire votre code secret"),
                            ),
                              RaisedButton(
                                color: Colors.lightGreen[400],
                                child: Text("Suivant"), onPressed: () async {
                                if(_formkey.currentState.validate()){
                                 await (Connectivity().checkConnectivity()).then((connectivityResult) async{
                                    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
                                     setState(() {
                                       loading = false;
                                       });
                                    await _database.reference().child("all_user").child(_numerodephone.text).once().then((DataSnapshot snapshot) async{
                                        uid = await (snapshot.value);
                                        print("avant modification =>  "+uid);
                                        //val = uid.split("//")[2];
                                    }).then((onValue) async{
                                      if(_codesecret.text == uid.split("//")[2]){
                                      await _database.reference().child("all_user").set({
                                        _numerodephone.text  : uid,
                                      }).then((onValue){
                                        setState(() {
                                          loading = true;
                                        });
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Next(num: _numerodephone.text)),);
                                      });
                                    }
                                    else{
                                      setState(() {
                                        loading = true;
                                        erreur = 'code secret incorrecte';
                                      });
                                    } // pas de touche
                                  });
                                }
                                }
                                );       
                                }
                                }
                                ),
                                SizedBox(height: 10,),
                                Text(erreur,style: TextStyle(color:Colors.red)),
                              ]
            ),
          ),
        ) 
        ),
    );
} 
}