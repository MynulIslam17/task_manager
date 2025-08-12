

 import 'package:get/get.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';

class SignUpController extends GetxController{

  bool _isRegister=false;
  String ? _errorMessage;

  bool get isRegister=>_isRegister;
  String ? get errorMsg=>_errorMessage;



  Future<bool> registerUser({required String email,required String fName,required String lName,required String mobile,required String password}) async{

     bool isSuccess=false;


      _isRegister=true;
      update();


      Map<String,dynamic>infoMap={
        "email":email,
        "firstName" : fName,
        "lastName" :lName,
         "mobile" : mobile,
          "password" : password
      };


      NetworkResponse response=await NetworkCaller.postRequest(url: ApiUrls.registerUr,body: infoMap);

      if(response.success){

        isSuccess=true;
      }else{

        _errorMessage=response.errorMsg!;

      }


      _isRegister=false;
        update();


      return isSuccess;


  }








}