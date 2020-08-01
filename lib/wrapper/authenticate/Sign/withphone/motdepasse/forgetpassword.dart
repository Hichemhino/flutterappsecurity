import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withphone/connexion/signphone.dart';

class Next extends StatefulWidget {
  final String num;
  Next({this.num});
  @override
  _NextState createState() => _NextState();
}

class _NextState extends State<Next> {
  TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FirebaseDatabase _database = FirebaseDatabase.instance; 
  bool passwordhiden = true,loading = true;
  String erreur = '',uid,numphone,text = '',message = '';
  List<String> list;
  @override
  Widget build(BuildContext context) {
    if(widget.num != null){
      setState(() {
        numphone = widget.num;
      });
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green[400],
        title : Text("Modifier votre mot de passe",style:TextStyle(fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Form(
          key: _formkey,
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                            // mot de passe
                             TextFormField(
                              validator: (val) => val.length >= 6 ? null : 'mot de passe non valide' ,
                              controller: _password,
                              obscureText: passwordhiden,
                              decoration: InputDecoration(hintText: "Nouveau Mot de passe",
                               suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), 
                               onPressed:()   {
                                 setState(() {
                                passwordhiden = !passwordhiden;
                                });
                               }                      
                             ),
                             ),
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
                                  await _database.reference().child("all_user").child(numphone).once().then((DataSnapshot snapshot) async {
                                         uid =  await (snapshot.value);
                                  }).then((onValue) async{
                                    setState(() {
                                      list = uid.split("//");
                                      list[1] = _password.text;
                                      uid = list[0]+"//"+list[1]+"//"+list[2];
                                      });
                                     print("mot de passe modifier" + uid);
                                    await _database.reference().child("all_user").set({
                                      numphone  : uid,
                                    });
                                     setState(() {
                                        loading = true;
                                      });
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Signphone(sms: "mot de passe modifier avec succés",)),);
                                });
                              }
                              }
                              );       
                              }
                              }
                              )
            ],
            ),
        ),
      )
      
    );
  }
}