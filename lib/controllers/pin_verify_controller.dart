

  import 'package:get/get.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';

class PinVerifyController extends GetxController {

 String? _errorMsg ;
 String ?  _successMsg;

 bool _isVerify=false;

 String ? get errorMessage => _errorMsg;
 String ? get successMessage => _successMsg;
 bool get isVerify =>_isVerify;



  Future<bool>   verifyOtp({required String email,required String otp}) async  {


   bool isSuccess=false;

   _isVerify=true;
   update();


   NetworkResponse response=await NetworkCaller.getRequest(ApiUrls.verifyPinUrl(email, otp));


   if(response.success){

    isSuccess=true;

    final data = response.body?["data"];

    _successMsg=data;


   }else{

    _errorMsg=response.errorMsg;


   }


   _isVerify=false;
   update();

   return isSuccess;


  }








}