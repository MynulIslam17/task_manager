
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager1/controllers/verify_email_controller.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/screens/pin_verify_screen.dart';
import 'package:task_manager1/ui/screens/sign_in_screen.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/rich_text.dart';
import 'package:task_manager1/ui/widgets/screen_background.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';

class VerifyEmailScreen extends StatefulWidget {
  static const String name="/email_verify_screen";

  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {



  final _verifyEmailController=Get.find<VerifyEmailController>();

  final _formKey=GlobalKey<FormState>();
  final TextEditingController _emailTEController=TextEditingController();
  bool _verifyEmailProgress =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

       body: ScreenBackground(
           child: Padding(padding: EdgeInsets.all(16),

             child: Form(
               key: _formKey,
               autovalidateMode: AutovalidateMode.onUserInteraction,

               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [

                   const SizedBox(height: 80,),

                   Text("Your Email Address",style: Theme.of(context).textTheme.titleMedium,),

                   const SizedBox(
                     height: 1,
                   ),

                   Text("A 6 digit verification code will send to your email address",style: Theme.of(context).textTheme.titleSmall,),


                   const SizedBox(
                     height: 10,
                   ),

                   TextFormField(
                     controller: _emailTEController,
                     textInputAction: TextInputAction.done,
                     validator: (value){
                       if(value==null || value.isEmpty){
                         return "Email is required";
                       }
                       if(!EmailValidator.validate(value)){
                         return "Invalid Email";
                       }
                       return null;

                     },

                     decoration: InputDecoration(
                       hintText: "Email"
                     ),
                   ),
                   const SizedBox(height: 20,),


                    GetBuilder<VerifyEmailController>(

                        builder: (controller){

                          return  Visibility(
                            visible:controller.isVerify==false ,
                            replacement: CenteredCircularProgressIndicator(),
                            child: ElevatedButton(
                                onPressed: _emailVerifyButton,
                                child: Icon(Icons.arrow_circle_right_outlined)
                            ),
                          ) ;
                        }
                    ),

                   const SizedBox(height: 20,),

                   Center(child: MyRichText(text: "Have an account ? ", colorText: "Sign In",
                         onClick: _tapSignIn,
                   )

                   )


                 ],
               ),
             ),



           )

       ),

    );
  }

  void _emailVerifyButton() async {

    if(_formKey.currentState!.validate()){
      // //if every things ok
      // // get the email and send code then go to next page
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pin send")));
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>PinVerifyScreen()));



       bool success=await _verifyEmailController.emailVerified(_emailTEController.text.trim());


      if(!mounted){
        return;
      }

       if(success){

         Get.to(PinVerifyScreen(email: _emailTEController.text.trim(),message: _verifyEmailController.successMessage,));
       }else{
         showSnackbarMesssage(context, _verifyEmailController.errorMsg!);
       }


    }


  }

  void _tapSignIn(){

    Navigator.pop(context);

  }


}
