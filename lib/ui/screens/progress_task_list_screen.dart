
   import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager1/controllers/progress_task_controller.dart';
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

    final _progressTaskController=Get.find<ProgressTaskController>();

   @override
  void initState() {
    // TODO: implement initState
     _fetchProgressTask();
    super.initState();
  }


     @override
     Widget build(BuildContext context) {
      return GetBuilder<ProgressTaskController>(
          builder: (controller){
            return  Visibility(
              visible: controller.progressTaskLoad==false,
              replacement: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CenteredCircularProgressIndicator(),
              ),
              child:(controller.taskList.isEmpty) ? Center(child: Text("No Completed Task Found",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 20,color:Colors.red),))
                  : ListView.builder(itemBuilder: (context,index){

                List<TaskModel> reversedTaskList= controller.taskList.reversed.toList();

                TaskModel task=reversedTaskList[index];


                return TaskCard(
                  task: task,
                  taskType: TaskCategory.Progress,
                  onStatusUpdate: _fetchProgressTask,

                  onDeleteTask: () async {
                    await _fetchProgressTask();
                  },


                );
              },
                itemCount: controller.taskList.length,
              ),
            );
          }
      );
     }


     Future<void> _fetchProgressTask() async{

       bool success= await _progressTaskController.retrieveProgressTask();

       if(!success && mounted){

         showSnackbarMesssage(context,_progressTaskController.errorMessage!);
       }

     }



   }
