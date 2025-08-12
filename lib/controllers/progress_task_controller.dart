

  import 'package:get/get.dart';

import '../data/models/task_model.dart';
import '../data/service/network_caller.dart';
import '../data/urls/api_urls.dart';

class ProgressTaskController extends GetxController{

  bool  _progressTaskLoad=false;

  String ? _errorMsg;

  List<TaskModel>_progressTasklist=[];

  bool get progressTaskLoad=>_progressTaskLoad;
  String ? get errorMessage=>_errorMsg;
  List<TaskModel> get  taskList=>_progressTasklist;


  Future<bool>  retrieveProgressTask() async{

    bool success=false;

    _progressTaskLoad=true;
    update();



    NetworkResponse response=await  NetworkCaller.getRequest(ApiUrls.progressTaskListUrl);


    if(response.success){

      List<TaskModel>newList=[];

      List<dynamic> data=response.body?["data"];


      for(Map<String,dynamic> map in data){

        newList.add(TaskModel.fromJson(map));

      }

      _progressTasklist=newList;

      _errorMsg=null;

      success=true;
    }else{

      _errorMsg=response.errorMsg ?? "Something went wrong";

    }


    _progressTaskLoad=false;

    update();

    return success;


  }





}