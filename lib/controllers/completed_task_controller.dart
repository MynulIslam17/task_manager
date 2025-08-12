

import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../data/models/task_model.dart';
import '../data/service/network_caller.dart';
import '../data/urls/api_urls.dart';

class CompletedTaskController extends  GetxController {

  bool  _CompletedProgrss=false;

  String ? _errorMsg;

  List<TaskModel>_completedTaskList=[];

  bool get taskProgress=>_CompletedProgrss;
  String ? get errorMessage=>_errorMsg;
  List<TaskModel> get  taskList=>_completedTaskList;


  Future<bool>  retrieveCompletedTask() async{

    bool success=false;

    _CompletedProgrss=true;
      update();



    NetworkResponse response=await  NetworkCaller.getRequest(ApiUrls.completedTaskListUrl);


    if(response.success){

      List<TaskModel>newList=[];

      List<dynamic> data=response.body?["data"];


      for(Map<String,dynamic> map in data){

        newList.add(TaskModel.fromJson(map));

      }

      _completedTaskList=newList;

      _errorMsg=null;

      success=true;
    }else{

      _errorMsg=response.errorMsg ?? "Something went wrong";

    }


    _CompletedProgrss=false;

    update();

    return success;


  }








}