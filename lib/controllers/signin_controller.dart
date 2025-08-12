

  import 'package:get/get.dart';
import 'package:task_manager1/data/models/userModel.dart';
import 'package:task_manager1/data/service/auth_controller.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';

class  SignInController extends GetxController{

  bool _signInProgress=false;
   String ? _errorMsg;


   bool get signInProgress=>_signInProgress;

   String? get  errorMessage=>_errorMsg;


   Future<bool> signIn({required String email,required String password}) async{

     bool isSuccess=false;


     _signInProgress=true;

    update();


    Map<String,String>loginInfo={

      "email":email,
        "password":password

    };

    NetworkResponse response=await NetworkCaller.postRequest(url: ApiUrls.loginUrl,body: loginInfo,cameFromSignIn: true);


    if(response.success){

      final data=response.body?["data"];
      final String token=response.body?["token"];

      UserModel model=UserModel.fromJson(data);

     await AuthController.saveDataAndToken(token, model);

      isSuccess=true;

      _errorMsg=null;


    }else{

      _errorMsg=response.errorMsg!;

    }


     _signInProgress=false;

     update();



    return isSuccess;




   }






  }