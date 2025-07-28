
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/screens/pass_reset_screen.dart';
import 'package:task_manager1/ui/screens/sign_in_screen.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/rich_text.dart';
import 'package:task_manager1/ui/widgets/screen_background.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';

class PinVerifyScreen extends StatefulWidget {

  static const String name="/pin_match_screen";

     final String email;
     final String ? message;


    const PinVerifyScreen({super.key,
      required this.email,
       this.message

    });

    @override
    State<PinVerifyScreen> createState() => _PinVerifyScreenState();
  }

  class _PinVerifyScreenState extends State<PinVerifyScreen> {



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

    bool _pinVerifyProgress=false;


   final TextEditingController _otpTEController=TextEditingController();


    @override
    Widget build(BuildContext context) {
      return Scaffold(

        body: ScreenBackground(
            child: SingleChildScrollView(
              child: Padding(padding: EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    const SizedBox(height: 80,),
                    
                    Text("PIN Verfication ",style: Theme.of(context).textTheme.titleMedium,),
                    const SizedBox(height: 1,),
                    Text("A 6 digit verification code will send to your email address",style: Theme.of(context).textTheme.titleSmall,),
                    const SizedBox(
                      height: 15,
                    ),


                    PinCodeTextField(
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeFillColor: Colors.white,
                        selectedColor: Colors.green,
                        inactiveColor:Colors.red
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.white,
                      controller: _otpTEController,


                        appContext: context,
                    ),
              
              
                    const SizedBox(
                        height: 20,
                    ),
              
                    Visibility(
                      visible: _pinVerifyProgress==false,
                       replacement: CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: _verifyButton,
                          child: Text("Verify")

                      ),
                    ),
              
                    const SizedBox(
                      height: 20,
                    ),
              
              
                    Center(
                      child: MyRichText(text: "Have an account ? ", colorText: "Sign In",
                          onClick: _tapSignIn
                      ),
                    )
              
              
              
                  ],
              
                ),
              
              ),
            )
        ),

      );
    }






    void _verifyButton() async{


     // if every field is filled then execute
      String otpString=_otpTEController.text.trim();

      if(otpString.length!=6){
        showSnackbarMesssage(context, "Please enter the 6-digit OTP");
        return;
      } // if not true then below code will not execute

     _pinVerifyProgress=true;

      NetworkResponse response =await NetworkCaller.getRequest(ApiUrls.verifyPinUrl(widget.email, _otpTEController.text));

      if(!mounted){
        return;
      }

      setState(() {
        _pinVerifyProgress=false;
      });

       if(response.success){
         final String data=response.body?["data"];
        showSnackbarMesssage(context, data);

        Navigator.push(context, MaterialPageRoute(builder: (context)=>PassResetScreen(email: widget.email,otp: _otpTEController.text,)));

       }else{
         showSnackbarMesssage(context, response.errorMsg!);
       }


    }

    void _tapSignIn(){

     Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate)=>false);

    }

  @override
  void dispose() {
    // TODO: implement dispose
    _otpTEController.dispose();
    super.dispose();
  }




  }
