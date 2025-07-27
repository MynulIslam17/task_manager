   import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager1/data/models/task_model.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';
import 'package:task_manager1/ui/widgets/task_card.dart';

import '../widgets/circular_progress_indicator.dart';

class CompletedTaskListScreen extends StatefulWidget {

     const CompletedTaskListScreen({super.key,

     });

     @override
     State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
     }

   class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {

  bool _completedTaskListShowingProgress=false;
  List<TaskModel> completedTaskList=[];



   @override
  void initState() {
    // TODO: implement initState
    _retrieveCompletedTask();
    super.initState();
  }


     @override
     Widget build(BuildContext context) {

       return Visibility(
           visible: _completedTaskListShowingProgress==false,
           replacement: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
               child: CenteredCircularProgressIndicator()),
         child: (completedTaskList.isEmpty) ? Center(child: Text("No Completed Task Found",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 20,color:Colors.red),))

             : ListView.builder(itemBuilder: (context,index){

            TaskModel task= completedTaskList[index];

        return TaskCard(task: task, taskType: TaskCategory.Completed,
        onStatusUpdate: (){
          _retrieveCompletedTask();
        },
        );


         },
         itemCount: completedTaskList.length,
         ),
       );
     }



     Future<void> _retrieveCompletedTask() async{

     setState(() {
       _completedTaskListShowingProgress=true;
     });



        NetworkResponse response=await NetworkCaller.getRequest(ApiUrls.completedTaskListUrl);

       setState(() {
         _completedTaskListShowingProgress=false;
       });

       if(response.success){

         List<TaskModel> list=[];

         final List<dynamic>data=response.body?["data"];

           for(Map<String,dynamic>task in data){

               list.add(TaskModel.fromJson(task));

           }


           setState(() {
             completedTaskList=list;
           });



       }else{

         if(mounted){
           showSnackbarMesssage(context,response.errorMsg!);
         }


       }




     }




   }
