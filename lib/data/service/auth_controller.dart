


   import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager1/data/models/userModel.dart';

class AuthController {

   static const String _userKey="user";
   static const String _tokenKey="token";


    static  UserModel ? userModel;
    static String ? Token;



   static Future<void> saveDataAndToken(String token, UserModel model) async{

      final SharedPreferences pref=await SharedPreferences.getInstance();

        await pref.setString(_userKey, jsonEncode(model.toJson())); // jsonEncode takes map/list convert it to jsonString
        await pref.setString(_tokenKey, token);


        userModel=model;
        Token=token;


   }


   static Future<void> updateData( UserModel upModel) async{

     final SharedPreferences pref=await SharedPreferences.getInstance();

     await pref.setString(_userKey, jsonEncode(upModel.toJson())); // jsonEncode takes map/list convert it to jsonString

     userModel=upModel;


   }

   
   
   static Future<void> getUserData()  async{
     
     final SharedPreferences pref= await SharedPreferences.getInstance();
     
     String ? token=pref.getString(_tokenKey);

     String ? jsonString=pref.getString(_userKey);

       userModel= UserModel.fromJson(jsonDecode(jsonString!));
       Token=token;

     
     
   }



    static Future<bool> isLogedIn() async{

      final SharedPreferences pref= await SharedPreferences.getInstance();

      String ? token= pref.getString(_tokenKey);

      if(token!=null ){
        await getUserData();
        return true;
      }else{
        return false;
      }

    }


   static Future<void> clearData() async{

     final SharedPreferences pref=await SharedPreferences.getInstance();
     await pref.clear();

     userModel=null;
     Token=null;

    }




   }