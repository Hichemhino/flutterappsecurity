import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcarsecur/services/auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutterappcarsecur/wrapper/authenticate/Sign/withemail/connexion/signemail.dart';
import 'package:flutterappcarsecur/wrapper/load/load.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
 // int screen_state;
 // Sign({this.screen_state});
}

class _PasswordState extends State<Password> {
    String message = '';
    final _formkey = GlobalKey<FormState>();
    final Services _auth = Services();
    TextEditingController _email = TextEditingController();
    final _emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+");
    bool loading = true;
    @override
  Widget build(BuildContext context) {
    return  !loading ?  Load() : Scaffold(
      appBar: AppBar(
        title: Text('Changer le mot de passe'),
        centerTitle: true,
        backgroundColor: Colors.green[400],     
         ),
       body: SingleChildScrollView(
                child: Center(
                child:
                  Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(hintText :"Veuillez Introduire votre email"),
                            controller: _email,
                            validator: (val) => val.contains(_emailRegex) ? null : 'Email non valide',
                         ),
                          RaisedButton(
                            child: Text('envoyer'),
                            color: Colors.green[400],
                            onPressed:() async {
                              if(_formkey.currentState.validate()){
                                await (Connectivity().checkConnectivity()).then((connectivityResult) async{
                                    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
                                      setState(() {
                                     loading = false;
                                     message = '';
                                    });
                                    
                                    await FirebaseDatabase.instance.reference().child("all_user").once().then((DataSnapshot snapshot)async{
                                     Map<dynamic, dynamic> phone = await snapshot.value;
                                     String emailcontenantpourcentage = _email.text.replaceAll('.', '%');
                                     if (phone.containsKey(emailcontenantpourcentage)){
                                    await _auth.resetpassword(_email.text).then((onValue){
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Sign(num:"Veuillez vérifier votre boite mail")));
                                });  
                                    }
                                    else {
                                      setState(() {
                                        loading = true;
                                        message = 'compte inexistant';
                                      });
                                    }

                                    });
                                   }
                                    else{
                                      setState(() {
                                       message = 'pas de connexion internet';
                                      });
                                    }
                                });                         
                               }
                              }  
                          ),
                          Text(message,style: TextStyle(color: Colors.green),),
                        ]    
                      ),
                    )
                      
                  )
                  ),
       )
           
         
       );
  }
}


