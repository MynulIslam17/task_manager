
   import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/task_card.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/api_urls.dart';
import '../widgets/snackbar.dart';

class ProgressTaskListScreen extends StatefulWidget {
     const ProgressTaskListScreen({super.key});

     @override
     State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
   }

   class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {

  bool _progressTaskListProgress=false;
  List<TaskModel>progressTaskList=[];

   @override
  void initState() {
    // TODO: implement initState
     _progressTaskRetrieve();
    super.initState();
  }


     @override
     Widget build(BuildContext context) {
      return Visibility(
        visible: _progressTaskListProgress==false,
        replacement: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CenteredCircularProgressIndicator(),
        ),
        child:(progressTaskList.isEmpty) ? Center(child: Text("No Completed Task Found",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 20,color:Colors.red),))
            : ListView.builder(itemBuilder: (context,index){
          TaskModel task=progressTaskList[index];
        return TaskCard(task: task, taskType: TaskCategory.Progress,
        onStatusUpdate: _progressTaskRetrieve,
        );
        },
          itemCount: progressTaskList.length,
        ),
      );
     }


     Future<void> _progressTaskRetrieve() async{

       setState(() {
         _progressTaskListProgress=true;
       });



       NetworkResponse response =await NetworkCaller.getRequest(ApiUrls.progressTaskListUrl);

       setState(() {
         _progressTaskListProgress=false;
       });

       if(response.success){

         List<TaskModel> list=[];
         final List<dynamic>data=response.body?["data"];

         for(Map<String,dynamic>task in data){
           list.add(TaskModel.fromJson(task));
         }


         setState(() {
           progressTaskList=list;
         });


       }else{
         showSnackbarMesssage(context, response.errorMsg!);
       }











     }



   }
