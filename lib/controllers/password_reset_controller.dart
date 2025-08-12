



import 'package:get/get.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';

class PasswordResetController extends GetxController {

  String? _errorMsg ;
  String ?  _successMsg;

  bool _isChange=false;

  String ? get errorMessage => _errorMsg;
  String ? get successMessage => _successMsg;
  bool get  isChange =>_isChange;



  Future<bool>   resetPassword({required String email,required String otp,required String password}) async  {


    bool isSuccess=false;

    _isChange=true;
    update();



    Map<String,dynamic>passInfo={
      "email":email,
      "OTP": otp,
      "password":password
    };





    NetworkResponse response=await NetworkCaller.postRequest(url: ApiUrls.passResetUrl,body: passInfo);


    if(response.success){

      isSuccess=true;

      final data = response.body?["data"];

      _successMsg=data;


    }else{

      _errorMsg=response.errorMsg;


    }


    _isChange=false;
    update();

    return isSuccess;


  }








}