import 'package:flutter/material.dart';

class AppUtils {
  BuildContext context;

  AppUtils({Key key, @required this.context});

  gotoPage({@required page}){
     Navigator.push(this.context, MaterialPageRoute(builder: (BuildContext context) => page));
  }

  goBack(){
    Navigator.pop(this.context);
  }
  
  String getDate(){
   // return DateFormat('dd/MM/yyyy —   HH:mm:ss:S').format(DateTime.now());
   return null;
  }
}