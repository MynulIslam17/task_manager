import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager1/controllers/singnup_controller.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/password_field.dart';
import 'package:task_manager1/ui/widgets/screen_background.dart';
import 'package:email_validator/email_validator.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';

class SignUpScreen extends StatefulWidget {

  static const String name="/sign_up_screen";

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {



  final TextEditingController _emailTEController=TextEditingController();
  final TextEditingController _fNameTEController=TextEditingController();
  final TextEditingController _lNameTEController=TextEditingController();
  final TextEditingController _mobileTEController=TextEditingController();
  final TextEditingController _passTEController=TextEditingController();



  final _signUpController=Get.find<SignUpController>();



  final _formKe=GlobalKey<FormState>();

  bool _obSecureText=true;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(

          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKe,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "Join With Us",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return "Email is required";
                        }

                        if(!EmailValidator.validate(value)){
                          return "Enter a valid email";
                        }

                        return null;
                      },

                      decoration: InputDecoration(
                      hintText: "Email"
                  )
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: _fNameTEController,
                    textInputAction:TextInputAction.next,
                    keyboardType: TextInputType.name,
                    validator: (value){
                        if(value==null || value.isEmpty){
                          return "FirstName is required";
                        }
                        return null ;
                    },
                    decoration: InputDecoration(
                        hintText: "First Name"
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                   controller: _lNameTEController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return "LastName is required";
                        }
                        return null ;
                      },
                      decoration: InputDecoration(
                          hintText: "Last Name"
                      )

                  ),

                  const SizedBox(height: 10,),


                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _mobileTEController,
                    textInputAction: TextInputAction.next,
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "MobileNo: is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Mobile",
                    ),
                  ),

                 const SizedBox(height: 10,),

                  PasswordField(passTEController: _passTEController, tapToSee: _tapToSee, obscureText: _obSecureText,
                  textHint: "password",

                    validator: (value){
                    if(value==null || value.isEmpty){
                      return "password is required";
                    }
                    if(value.length  <= 6){
                      return "password must have more then 6 character";
                    }
                    return null;

                    },

                  ),

                  const SizedBox(height: 25,),


                  GetBuilder<SignUpController>(

                      builder: (controller){

                      return   Visibility(
                      visible:controller.isRegister ==false ,
                      replacement: CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _signUpButton,
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    );

                  }

                  ),

                  const SizedBox(height: 20,),


                 Center(
                   child: RichText(text: TextSpan(
                     text: "Have an account ? ",
                     style: TextStyle(fontSize: 13,color: Colors.black,
                       letterSpacing: 0.3
                     ),
                     children: [

                       TextSpan(
                         recognizer: TapGestureRecognizer()..onTap=_tapSignIn,
                         text: "Sign In",
                         style: TextStyle(
                           fontSize: 15,
                           fontWeight: FontWeight.w700,
                           color: Colors.green
                         )
                       )


                     ]

                   ),),
                 )



                ],
              ),
            ),
          ),
        ),
      ),
    );


  }

  void _tapToSee(){

   setState(() {
     _obSecureText=!_obSecureText;
   }); // reverse the bool value
  }


  void _signUpButton() async{

    if(_formKe.currentState!.validate()){


      bool success =await _signUpController.registerUser(email: _emailTEController.text.trim(),
          fName: _fNameTEController.text.trim(),
          lName: _lNameTEController.text.trim(),
          mobile: _mobileTEController.text.trim(),
          password: _passTEController.text);

      if(!mounted){
        return;
      }

      if(success){
        showSnackbarMesssage(context, "User registered successfully.please login .");

        _emailTEController.clear();
        _lNameTEController.clear();
        _fNameTEController.clear();
        _mobileTEController.clear();
        _passTEController.clear();

      }else{
        showSnackbarMesssage(context, _signUpController.errorMsg!);
      }



    }


  }







  void _tapSignIn(){
    //Navigator.pop(context);
    Get.back();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTEController.dispose();
    _fNameTEController.dispose();
    _lNameTEController.dispose();
    _mobileTEController.dispose();
    _passTEController.dispose();
    super.dispose();
  }



}
