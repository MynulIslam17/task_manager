

   import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager1/data/models/userModel.dart';
import 'package:task_manager1/data/service/auth_controller.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager1/ui/screens/sign_up_screen.dart';
import 'package:task_manager1/ui/screens/verify_email_screen.dart';
import 'package:task_manager1/ui/utils/aseets_path.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';

import '../widgets/password_field.dart';
import '../widgets/screen_background.dart';
import '../widgets/snackbar.dart';

class SignInScreen extends StatefulWidget {

  static const String name="/sign_in_screen";


     const SignInScreen({super.key});

     @override
     State<SignInScreen> createState() => _SignInScreenState();
   }

   class _SignInScreenState extends State<SignInScreen> {



    final _formKey=GlobalKey<FormState>();
    final TextEditingController _emailTEController=TextEditingController();
    final TextEditingController  _passTEController=TextEditingController();

    bool _obscureText =true;
    bool _signinProgress=false;

     @override
     Widget build(BuildContext context) {
       return Scaffold(


         body: ScreenBackground(
           child:SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Form(
                 key: _formKey,
                 autovalidateMode: AutovalidateMode.onUserInteraction,

                 child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                  const SizedBox(height: 80,),
                     Text("Get Started With ",style: Theme.of(context).textTheme.titleMedium,),
                   const  SizedBox(height: 24,),

                     TextFormField(
                       controller: _emailTEController,
                       validator: (value){

                        if(value==null || value.isEmpty){
                          return "Email is required";
                        }
                        if(!EmailValidator.validate(value)){
                          return "Invalid Email";
                        }

                         return null;

                       },
                      textInputAction: TextInputAction.next,
                       keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email"
                      ),
                     ),
                     const SizedBox(height: 10,),

                      // password field

                      PasswordField(passTEController: _passTEController,tapToSee: _tapToSeePassword,obscureText: _obscureText,
                      textHint:"password",
                        validator: (value){

                         if(value== null || value.isEmpty){
                           return "password is required";
                         }
                         return null;

                        },

                      ),

                     const SizedBox(height: 20,),


                     Visibility(
                       visible: _signinProgress==false,
                       replacement:CenteredCircularProgressIndicator(),
                       child: ElevatedButton(
                           onPressed:_onTapSignInButton,
                           child: Icon(Icons.arrow_circle_right_outlined)
                       ),
                     ),


                     Center(
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           TextButton(onPressed: _forgetPassText,
                               child: Text("Forget Password ?")),

                           const SizedBox(height: 5,),

                           RichText(text: TextSpan(
                               text: "Don't have an account ? ",
                               style: TextStyle(color: Colors.black,
                                   fontSize: 13),
                               children: [
                                 TextSpan(
                                       recognizer: TapGestureRecognizer()..onTap=_tapSignup,
                                     text: "Sign up",
                                     style: TextStyle(fontSize:15,
                                         color: Colors.green,
                                         fontWeight: FontWeight.w700
                                     )
                                 )
                               ]

                           )

                           )
                         ],
                       ),
                     )





                   ],


                 ),
               ),
             ),
           )
         ),



       );
     }

     void _tapToSeePassword(){

        setState(() {

          if(_obscureText==true){
            _obscureText=false;
          }else{
            _obscureText=true;
          }

        });
     }



     void _onTapSignInButton() async{ // button to submit email pass

       if(_formKey.currentState!.validate()){


         _signinProgress=true;
         setState(() {

         });

         Map<String,dynamic>loginInfo={
           "email":_emailTEController.text.trim(),
           "password":_passTEController.text
         };


         NetworkResponse response=await NetworkCaller.postRequest(url: ApiUrls.loginUrl,body: loginInfo,cameFromSignIn: true );

         setState(() {
           _signinProgress=false;
         });



         if(response.success){

           final token=response.body?["token"];
           final data=response.body?["data"];


           UserModel model=UserModel.fromJson(data);

           await AuthController.saveDataAndToken(token, model);

           if(!mounted){
             return;
           }
           Navigator.pushNamedAndRemoveUntil(context, MainNavBarHolderScreen.name,(predicate)=>false);


         }else{

              if(mounted){
                showSnackbarMesssage(context, response.errorMsg!);
              }


         }

       }





     }

     void _forgetPassText(){

       Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyEmailScreen()));

     }

     void _tapSignup(){

       Navigator.pushNamed(context, SignUpScreen.name);

     }

    @override
  void dispose() {
    // TODO: implement dispose
      _emailTEController.dispose();
      _passTEController.dispose();
    super.dispose();
  }



   }






