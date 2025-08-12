
 import 'package:get/get.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';

class VerifyEmailController extends GetxController{

  bool _isVerify=false;
  String ? _errorMessage ;
  String ? _successMessage;

  bool get isVerify=> _isVerify;
  String ? get errorMsg =>_errorMessage;
  String ? get successMessage =>_successMessage;


    Future<bool> emailVerified(String email) async{

      bool isSuccess=false;

      _isVerify=true;
       update();


       NetworkResponse response=await NetworkCaller.getRequest(ApiUrls.verifyEmailUrl(email));

       if(response.success){

         final data=response.body?["data"];

            _successMessage=data;

            isSuccess=true;

       }else{
         _errorMessage=response.errorMsg!;

       }


       _isVerify=false;
       update();

       return isSuccess;






    }




}