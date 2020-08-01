import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Load extends StatefulWidget {
  final String message;
  Load({this.message});
  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {
  String message = '';
  @override
  Widget build(BuildContext context) {
    if(widget.message != null){
      message = widget.message;
    }
    return Container(
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: <Widget>[ 
                   SpinKitFadingCircle(
                         color: Colors.green,
                         size: 100.0,
                      ),
                  SizedBox(height : 10.0),
                  Text('veuillez patienter quelques instants...', style: TextStyle(color: Colors.green, fontSize: 13,decoration: TextDecoration.none)),
                  Text(message,style: TextStyle(color: Colors.green, fontSize: 13,decoration: TextDecoration.none) )
                ],
              ),
            ),
          ),
    );
  }
}