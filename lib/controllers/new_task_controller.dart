



import 'package:get/get.dart';
import 'package:task_manager1/data/models/task_model.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';

class NewTaskController extends  GetxController {

  bool  _progressNewTask=false;

  String ? _errorMsg;

  List<TaskModel>_newTaskList=[];

   bool get taskProgress=>_progressNewTask;
   String ? get errorMessage=>_errorMsg;
   List<TaskModel> get  taskList=>_newTaskList;


  Future<bool>  retrieveNewTask({bool showLoading = true}) async{

    bool success=false;

    if(showLoading){
      _progressNewTask=true;
      update();
    }


    NetworkResponse response=await  NetworkCaller.getRequest(ApiUrls.newTaskListUrl);


    if(showLoading){
      _progressNewTask=false;
      update();
    }


    if(response.success){

      List<TaskModel>newList=[];

      List<dynamic> data=response.body?["data"];


      for(Map<String,dynamic> map in data){

        newList.add(TaskModel.fromJson(map));

      }

      _newTaskList=newList;

      _errorMsg=null;

     success=true;
    }else{

      _errorMsg=response.errorMsg ?? "Something went wrong";

    }


    update();

    return success;


  }








}