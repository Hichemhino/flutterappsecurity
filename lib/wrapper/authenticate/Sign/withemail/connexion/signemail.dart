import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcarsecur/services/auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withemail/inscription/registeremail.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withemail/motdepasse/motdepasse.dart';
import 'package:flutterappcarsecur/wrapper/home/page2.dart';
import 'package:flutterappcarsecur/wrapper/load/load.dart';
import 'package:encrypt/encrypt.dart' as  encrypt;

class Sign extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
 final String num;
 Sign({this.num});
}
class _SignState extends State<Sign> {
  final Services _auth = Services();
  final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+");
  final _formkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool loading = true;
  bool passwordhiden = true;
  String message = '';
  String erreur = '';
  String uid;
  String mylist;
  @override
  Widget build(BuildContext context) {
    if (widget.num != null){
      setState(() {
        message = widget.num;
      });
    }
    if(loading){
      return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[400],
        title: RichText(
                text: TextSpan(
                    children: [
                        TextSpan(text:"connexion avec email",style: TextStyle( fontSize: 20 )),
                      ],
                ),
              ),
         /* actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.home,color: Colors.white,),
            label: Text('home', style : TextStyle(color: Colors.white ,fontSize: 15 )),
            onPressed: () async{
               dynamic result = _auth.singOutAccount();
               if(result != null){
                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Wrapper()),);
               }
            },
          ),
          ],*/
        ),
        body: 
        SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top :90.0, left: 8, right: 8),
              child: Column(
              children: <Widget>[
                Form(
                  key: _formkey,
                  child : Column(
                    children : <Widget>[
                    // email
                    TextFormField(
                        validator: (val) => val.contains(emailRegex) ? null : 'email non valide' ,
                        controller: _email,
                        decoration: InputDecoration(hintText: "Email"),
                      ),
                    SizedBox(height: 10),
                    // mot de passe
                    TextFormField(
                          validator: (val) => val.length >= 6 ? null : 'mot de passe non valide' ,
                          controller: _password,
                          obscureText: passwordhiden,
                          decoration: InputDecoration(hintText: "Mot de passe",
                          suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), 
                          onPressed:()   {
                          setState(() {
                            passwordhiden = !passwordhiden;
                          });
                         }                      
                        ),),
                      ),
                    SizedBox(height: 10.0),
                    // boutton
                    RaisedButton(
                        color: Colors.lightGreen[400],
                        child: Text("connexion"), onPressed: () async {
                          if(_formkey.currentState.validate()){
                           await (Connectivity().checkConnectivity()).then((connectivityResult) async{
                            if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                            setState(() {
                             loading = false;
                             erreur = '';
                            });  
                            // ici le 260/07
                              final key = encrypt.Key.fromLength(32);
                              final iv = encrypt.IV.fromLength(8);
                              final encrypter =  encrypt.Encrypter(encrypt.Salsa20(key));
                              var cryptedMail = encrypter.encrypt(_email.text, iv: iv).base64;
                          await FirebaseDatabase.instance.reference().child("users").once().then((DataSnapshot snapshot) async{           
                                 Map<dynamic, dynamic> values = snapshot.value;
                          if(values.containsKey(cryptedMail)){
                           dynamic result = await _auth.signInwithEmailandPassword(_email.text,_password.text);
                           if(result != null){
                              DatabaseReference _ref = FirebaseDatabase.instance.reference().child("all_user").child(_email.text
                              .replaceAll(".","%"));
                              await  _ref.once().then((DataSnapshot snapshot){
                                    uid = snapshot.value;
                              }).then((onValue) async {
                                  setState(() {
                                   // loading = true;
                                    erreur = '';
                                });
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Suite(num: uid)));
                              });
                           }
                            else{
                              setState(() {
                              loading = true;
                               erreur = 'mot de passe ou email incorrecte';
                            }); 
                            }
                            }
                            else{
                              setState(() {
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
                    Text(erreur,style: TextStyle(color: Colors.red),),
                    SizedBox(height: 5.0),
                    Text(message , style: TextStyle(color : Colors.green)),
                    SizedBox(height: 10.0),
                    // mot de passe oublié
                    InkWell(
                     child: Text("mot de passe oublié ?" , style: TextStyle(color: Colors.grey[600],decoration: TextDecoration.underline),),
                     onTap:() {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Password()),);
                     }
                    ),
                      SizedBox(height: 10.0),
                    // inscription
                    InkWell(
                        child: Text("Cliquez ici pour S'inscrire " , style: TextStyle(color: Colors.grey[600],decoration: TextDecoration.underline),),
                        onTap:()  {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Register()),);
                          },
                      ),     
                    ]

                  ),
                ),
              ],
          ),
            ),
        ),

    );
     }
    else{
      return Load();
    }
     
  }
  }
