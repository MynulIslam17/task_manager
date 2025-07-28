
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/screens/sign_in_screen.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/password_field.dart';
import 'package:task_manager1/ui/widgets/rich_text.dart';
import 'package:task_manager1/ui/widgets/screen_background.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';

class PassResetScreen extends StatefulWidget {

  static const String name="/pass_reset_screen";

  final String email;
  final String otp;
  final String ? message;

    const PassResetScreen({super.key,
    required this.email,
      required this.otp,
      this.message
    });

    @override
    State<PassResetScreen> createState() => _PassResetScreenState();
  }

  class _PassResetScreenState extends State<PassResetScreen> {



  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_){

      if(widget.message!=null && widget.message!.isNotEmpty){
        showSnackbarMesssage(context, widget.message!);
      }

    });

    super.initState();
  }


  final TextEditingController _passTEController=TextEditingController();
  final TextEditingController _confirmPassTEController=TextEditingController();
  final _formKey= GlobalKey<FormState>();

  bool _obSecureText1=true;
  bool _obSecureText2=true;


  bool _passwordResetProgress=false;


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

                      Visibility(
                        visible: _passwordResetProgress==false,
                        replacement: CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                            onPressed: _passConfirm,
                            child: Text("Confirm")
                        ),
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

    void _passConfirm() async{

      if(_formKey.currentState!.validate()){

        setState(() {
          _passwordResetProgress=true;
        });

        Map<String,dynamic> passInfo={
          "email":widget.email,
          "OTP":widget.otp,
          "password":_confirmPassTEController.text
        };

        NetworkResponse response=await NetworkCaller.postRequest(url: ApiUrls.passResetUrl,body: passInfo);
        if(!mounted){
          return ;
        }


        setState(() {
          _passwordResetProgress=false;
        });

        if(response.success){

          final String  data=response.body?["data"];
          if(mounted){
            showSnackbarMesssage(context, data);
          }


          _confirmPassTEController.clear();
          _passTEController.clear();


        }else{
            if(mounted){
              showSnackbarMesssage(context, response.errorMsg!);
            }

        }




      }

    }


    void _tapSignIn(){

      Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate)=>false);

    }

    @override
  void dispose() {
    // TODO: implement dispose
      _passTEController.dispose();
      _confirmPassTEController.dispose();
    super.dispose();
  }


  }
