   import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager1/controllers/completed_task_controller.dart';
import 'package:task_manager1/data/models/task_model.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';
import 'package:task_manager1/ui/widgets/task_card.dart';

import '../../controllers/new_task_controller.dart';
import '../widgets/circular_progress_indicator.dart';

class CompletedTaskListScreen extends StatefulWidget {

     const CompletedTaskListScreen({super.key,

     });

     @override
     State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
     }

   class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {


    final  _completedTaskController=Get.find<CompletedTaskController>();



   @override
  void initState() {
    // TODO: implement initState
    _fetchCompletedTask();
    super.initState();
  }


     @override
     Widget build(BuildContext context) {

       return GetBuilder<CompletedTaskController>(

           builder: (controller){

           return Visibility(
             visible: controller.taskProgress==false,
             replacement: Padding(
                 padding: EdgeInsets.symmetric(vertical: 10),
                 child: CenteredCircularProgressIndicator()),
             child: (controller.taskList.isEmpty) ? Center(child: Text("No Completed Task Found",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 20,color:Colors.red),))

                 : ListView.builder(itemBuilder: (context,index){

               List<TaskModel> reversedTaskList= controller.taskList.reversed.toList();

               TaskModel task=reversedTaskList[index];

               return TaskCard(task: task,
                 taskType: TaskCategory.Completed,
                 onStatusUpdate: ()async{
                  await _fetchCompletedTask();
                 },
                 onDeleteTask: ()async{
                   await _fetchCompletedTask();
                 },


               );


             },
               itemCount: controller.taskList.length,
             ),
           );

       }
       );
     }



     Future<void> _fetchCompletedTask() async{

       bool success=await _completedTaskController.retrieveCompletedTask();

       if(!success && mounted){
         showSnackbarMesssage(context, _completedTaskController.errorMessage!);
       }


     }




   }
