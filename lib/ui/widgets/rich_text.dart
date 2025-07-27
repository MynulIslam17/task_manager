

 import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyRichText extends StatelessWidget {
  final String text;
  final String  colorText;
  final  VoidCallback onClick;
   const MyRichText({super.key,
     required this.text,
     required this.colorText,
     required this.onClick
   });

   @override
   Widget build(BuildContext context) {
     return   RichText(text: TextSpan(
        text:text,
       style: TextStyle(
         fontSize: 13,
         color: Colors.grey,
         letterSpacing: 0.3
       ),
       children: [
         TextSpan(

           text: colorText,
           style: TextStyle(
             fontSize: 15,
             fontWeight: FontWeight.w700,
             color: Colors.green
           ),
           recognizer: TapGestureRecognizer()..onTap=onClick


         )
       ]

     )
     );
   }
 }
