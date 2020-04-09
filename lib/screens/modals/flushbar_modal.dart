

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class Modal{

  Flushbar flushbar(String message, {IconData icon = Icons.info_outline, String type:'info'} ){
    return Flushbar(

      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      messageText: Text(message, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      icon: Icon(
        icon,
        size: 28.0,
        color: Colors.black,
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 5),

    );
  }

}