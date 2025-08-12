
 import 'package:get/get.dart';

import '../data/models/task_model.dart';
import '../data/service/network_caller.dart';
import '../data/urls/api_urls.dart';

class CanceledTaskController extends GetxController{

  bool  _canceledTaskProgress=false;

  String ? _errorMsg;

  List<TaskModel>_canceledTaskList=[];

  bool get taskProgress=>_canceledTaskProgress;
  String ? get errorMessage=>_errorMsg;
  List<TaskModel> get  taskList=>_canceledTaskList;


  Future<bool>  retrieveCanceledTask() async{

    bool success=false;

    _canceledTaskProgress=true;
    update();



    NetworkResponse response=await  NetworkCaller.getRequest(ApiUrls.canceledTaskListUrl);


    if(response.success){

      List<TaskModel>newList=[];

      List<dynamic> data=response.body?["data"];


      for(Map<String,dynamic> map in data){

        newList.add(TaskModel.fromJson(map));

      }

      _canceledTaskList=newList;

      _errorMsg=null;

      success=true;
    }else{

      _errorMsg=response.errorMsg ?? "Something went wrong";

    }


    _canceledTaskProgress=false;

    update();

    return success;


  }








}