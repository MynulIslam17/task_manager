import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {

   final TextEditingController passTEController;
   final VoidCallback tapToSee;
   final bool obscureText ;
   final String textHint;
   final String? Function(String?) ? validator;



  const PasswordField({
    super.key,
    required this.passTEController,
    required this.tapToSee,
    required this.obscureText,
    required this.textHint,
    this.validator

  });



  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: passTEController,
      obscureText: obscureText,

      textInputAction: TextInputAction.done,
      validator:validator ,


      decoration: InputDecoration(
          hintText:textHint,
          suffixIcon: IconButton(onPressed:tapToSee,
              icon: Icon(Icons.remove_red_eye))
      ),


    );
  }







}