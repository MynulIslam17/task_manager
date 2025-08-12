

 import 'package:get/get.dart';
import 'package:task_manager1/data/models/task_count_summary_model.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';


class TaskCountController extends GetxController {

  bool _taskCountProgress=false;
  String ? _errorMsg;
  List<TaskCountSummaryModel>_countList=[];


   bool get countProgress=>_taskCountProgress;
   String ? get errorMessage => _errorMsg;

   List<TaskCountSummaryModel> get taskCountList =>_countList;


  Future<bool>  taskSummaryCount({bool showLoading=true}) async{

     bool isSuccess=false;

    if(showLoading){
      _taskCountProgress=true;
      update();
    }


    NetworkResponse response=await NetworkCaller.getRequest(ApiUrls.taskCountUrl);

     if(showLoading){
       _taskCountProgress=false;
       update();
     }



    if(response.success){

      List<TaskCountSummaryModel> newList=[];

      List<dynamic> data=response.body?["data"];

      for(Map<String,dynamic> map in data){

        newList.add(TaskCountSummaryModel.fromJsom(map));


      }

      _countList=newList;
      _errorMsg=null;
      isSuccess=true;



    }else{

      _errorMsg=response.errorMsg!;

    }



    update();
    return isSuccess;



  }





}