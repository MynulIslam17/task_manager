


  import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:task_manager1/app.dart';
import 'package:task_manager1/data/service/auth_controller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager1/ui/screens/sign_in_screen.dart';


class NetworkResponse{

  final int statusCode;
  final bool success ;
  final String ? errorMsg;
  final Map<String,dynamic>? body;

  NetworkResponse({required this.statusCode, required this.success,  this.errorMsg,  this.body});


}



class  NetworkCaller {

  static const String  errorMessage="Something went wrong";
  static const unAuthorizedError="Unauthorized user please login again";

    static Future<NetworkResponse> getRequest(String url) async{

           try{

             Map<String,String>header={
               // content type not required for get method
               "token": AuthController.Token ?? ""
             };
              
              _logRequest(url, null,header);

             final uri=Uri.parse(url);
             final response = await http.get(uri,headers: header);
             _logResponse(url, response);


             if(response.statusCode==200){
               final decodedJson=jsonDecode(response.body);
               return  NetworkResponse(statusCode: response.statusCode, success: true,body:decodedJson);

             }else if(response.statusCode==401){

               _isUnAuthorized();

               return NetworkResponse(statusCode: response.statusCode, success: false,errorMsg: unAuthorizedError);

             }


             else{
               final decodedJson=jsonDecode(response.body);
               String data=decodedJson["data"] ?? errorMessage;

               return NetworkResponse(statusCode: response.statusCode, success: false,errorMsg: data);
             }

           }
           catch (e){
             return NetworkResponse(statusCode: -1, success: false,errorMsg: e.toString());
           }





       
     }


     static Future<NetworkResponse> postRequest({required String url , Map<String,dynamic>?body, bool cameFromSignIn=false}  )async{


     try{

        Map<String,String>header={
          "Content-Type": "application/json",
          "token"        : AuthController.Token ?? " "
        };
       
       _logRequest(url, body,header);

       final uri =Uri.parse(url);
       

       final response=await http.post(
           uri,
           headers: header,
           body: jsonEncode(body)

       );

       _logResponse(url, response);

       if(response.statusCode==200){

         final decodedJson=jsonDecode(response.body);

         return NetworkResponse(statusCode: response.statusCode, success: true, body: decodedJson);

        }else if(response.statusCode==401){

         if(cameFromSignIn==false){ // it check if statuscode 401 comes from signinpage then user on that page already so not required to pass again
           _isUnAuthorized();
         }

         return NetworkResponse(statusCode: response.statusCode, success: false,errorMsg : unAuthorizedError);
       }

       else{

         final decodedJson=jsonDecode(response.body);

         return NetworkResponse(statusCode: response.statusCode, success: false,errorMsg: decodedJson["data"]?? errorMessage);


       }

     }catch(e){
       return NetworkResponse(statusCode: -1, success: false,errorMsg: e.toString());
     }


     }




 static void  _logRequest(String url,Map<String,dynamic>?body,Map<String,String>header){

    debugPrint("========= Request ====================\n"
        "url : $url\n"
        "body : $body\n"
        "header : $header\n"
        "===========================================");

  }


 static void  _logResponse(String url, http.Response response,){

      debugPrint("========== Response=====================\n"
          "Url : $url\n"
          "statusCode: ${response.statusCode}\n"
          "body: ${response.body}"

      );


  }



   static Future<void> _isUnAuthorized()async{ // if token expired or get 401 error

      await AuthController.clearData();

     Navigator.pushNamedAndRemoveUntil(TaskManger.navigator.currentContext!, SignInScreen.name, (predicate)=>false);

   }




}







