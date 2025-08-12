
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager1/controllers/pin_verify_controller.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/screens/pass_reset_screen.dart';
import 'package:task_manager1/ui/screens/sign_in_screen.dart';
import 'package:task_manager1/ui/screens/sign_up_screen.dart';
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
  
  
  final _pinVerifyController=Get.find<PinVerifyController>();

  final TextEditingController _otpTEController=TextEditingController();



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
                    Text( "A 6 digit verification code will send to your email address",style: Theme.of(context).textTheme.titleSmall,),
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
              
                    GetBuilder<PinVerifyController>(
                        builder: (controller){
                      
                          return Visibility(
                            visible: controller.isVerify==false,
                            replacement: CenteredCircularProgressIndicator(),
                            child: ElevatedButton(
                                onPressed: _verifyButton,
                                child: Text("Verify")

                            ),
                          );
                    }),
              
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
      }
      
      bool success=await _pinVerifyController.verifyOtp(email: widget.email, otp: otpString);
      
      
      if(!mounted){
        return;
      }
      
      if(success){
        Get.to(PassResetScreen(email: widget.email, otp: otpString,message: _pinVerifyController.successMessage,));
      }else{
        showSnackbarMesssage(context, _pinVerifyController.errorMessage!);
      }

    }

    void _tapSignIn(){

      Get.offAllNamed(SignInScreen.name);

    }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }




  }
