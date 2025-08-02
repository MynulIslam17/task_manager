

     import 'dart:collection';

import 'package:get/get.dart';
import 'package:task_manager1/data/models/task_model.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';

class NewTaskController extends  GetxController {

  bool  progressNewTask=false;
  //bool progressTaskCount=false;
  String ? errorMsg;

  List<TaskModel>newTaskList=[];


  Future<bool>  retrieveNewTask({bool showLoading = true}) async{

    bool success=false;

    if(showLoading){
      progressNewTask=true;
      update();
    }


    NetworkResponse response=await  NetworkCaller.getRequest(ApiUrls.newTaskListUrl);


    if(showLoading){
      progressNewTask=false;
      update();
    }


    if(response.success){

      List<TaskModel>newList=[];

      List<dynamic> data=response.body?["data"];


      for(Map<String,dynamic> map in data){

        newList.add(TaskModel.fromJson(map));

      }

      newTaskList=newList;

       errorMsg=null;

     success=true;
    }else{

      errorMsg=response.errorMsg ?? "Something went wrong";

    }


    update();

    return success;


  }








}