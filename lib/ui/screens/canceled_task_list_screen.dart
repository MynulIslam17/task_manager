   import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:task_manager1/controllers/canceled_task_controller.dart';
import 'package:task_manager1/data/models/task_model.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';
import 'package:task_manager1/ui/widgets/task_card.dart';

class CanceledTaskListScreen extends StatefulWidget {
     const CanceledTaskListScreen({super.key});

     @override
     State<CanceledTaskListScreen> createState() => _CanceledTaskListScreenState();
   }

   class _CanceledTaskListScreenState extends State<CanceledTaskListScreen> {

   final _canceledTaskController=Get.find<CanceledTaskController>();

    @override
  void initState() {
    // TODO: implement initState
      _fetchCanceledTask();
    super.initState();
  }


     @override
     Widget build(BuildContext context) {
       return GetBuilder<CanceledTaskController>(
           builder: (controller){
             return Visibility(
               visible: controller.taskProgress==false,
               replacement: Padding(
                 padding: const EdgeInsets.symmetric(vertical: 10),
                 child: CenteredCircularProgressIndicator(),
               ),
               child:(controller.taskList.isEmpty) ? Center(child: Text("No Completed Task Found",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 20,color:Colors.red),))
                   : ListView.builder(itemBuilder: (context,index){


                 List<TaskModel> reversedTaskList= controller.taskList.reversed.toList();
                 TaskModel task=reversedTaskList[index];

                 return TaskCard(task: task, taskType: TaskCategory.Canceled,
                   onStatusUpdate: ()async{
                   await  _fetchCanceledTask();
                   },

                   onDeleteTask: ()async{

                     await _fetchCanceledTask();

                   },

                 );
               },
                 itemCount: controller.taskList.length,


               ),
             );
           }
       );
     }



     Future<void> _fetchCanceledTask() async{

       bool success=await _canceledTaskController.retrieveCanceledTask();

       if(!success && mounted){
         showSnackbarMesssage(context, _canceledTaskController.errorMessage!);
       }



     }


   }
