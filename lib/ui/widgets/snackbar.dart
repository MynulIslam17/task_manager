
    import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackbarMesssage(BuildContext context ,String msg){

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));


}