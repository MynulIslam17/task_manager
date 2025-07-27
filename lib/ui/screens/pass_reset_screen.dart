
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager1/ui/screens/sign_in_screen.dart';
import 'package:task_manager1/ui/widgets/password_field.dart';
import 'package:task_manager1/ui/widgets/rich_text.dart';
import 'package:task_manager1/ui/widgets/screen_background.dart';

class PassResetScreen extends StatefulWidget {

  static const String name="/pass_reset_screen";

    const PassResetScreen({super.key});

    @override
    State<PassResetScreen> createState() => _PassResetScreenState();
  }

  class _PassResetScreenState extends State<PassResetScreen> {



  final TextEditingController _passTEController=TextEditingController();
  final TextEditingController _confirmPassTEController=TextEditingController();
  final _formKey= GlobalKey<FormState>();

  bool _obSecureText1=true;
  bool _obSecureText2=true;

    @override
    Widget build(BuildContext context) {
      return Scaffold(

        body: ScreenBackground(
            child: SingleChildScrollView(
              child: Padding(padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(
                        height: 80,
                      ),
                      Text("Set Password ",style: Theme.of(context).textTheme.titleMedium,),
                      const SizedBox(height: 1,),
                      Text("Password should be more then 6 character ",style: Theme.of(context).textTheme.titleSmall,),

                      const SizedBox(height: 20,),

                   PasswordField(passTEController: _passTEController, tapToSee: _togglePassVisibility1, obscureText: _obSecureText1,textHint: "Password",

                       validator: (value){

                         if(value==null || value.isEmpty){
                           return "password is required";
                         }
                         if((value.trim().length<=6)){
                           return "password is too short";
                         }
                         return  null;

                       },

                   ),

                    const  SizedBox(height: 10,),


                      PasswordField(passTEController: _confirmPassTEController, tapToSee: _togglePassVisibility2, obscureText: _obSecureText2,textHint: "Confirm password",

                        validator: (String ?value){ // it can be also write (value)
                        if(value==null || value.isEmpty){
                          return "password is required";
                        }
                        if(value.trim().length <=6){
                          return "password is too short";
                        }

                        if(value!=_passTEController.text.trim()){
                          return "password do not match";
                        }

                        return null ;

                        },
                      ),


                      const SizedBox(height: 20,),

                      ElevatedButton(
                          onPressed: _passConfirm,
                          child: Text("Confirm")
                      ),

                      const SizedBox(height: 25,),

                      Center(child: MyRichText(text: "Have an account ? ", colorText: "Sign In ",
                          onClick: _tapSignIn
                      ),)




                    ],
                  ),
                ),
              
              ),
            )

        ),


      );
    }

  void _togglePassVisibility1(){
    setState(() {
      _obSecureText1=!_obSecureText1;

    });
  }

  void _togglePassVisibility2(){
      setState(() {
        _obSecureText2=!_obSecureText2;
      });
  }

    void _passConfirm(){

      if(_formKey.currentState!.validate()){

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pass change")));
      }

    }


    void _tapSignIn(){

      Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate)=>false);

    }


  }
