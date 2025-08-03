  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager1/controllers/new_task_controller.dart';
import 'package:task_manager1/controllers/taskCount_controller.dart';
import 'package:task_manager1/data/models/task_count_summary_model.dart';
import 'package:task_manager1/data/models/task_model.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/screens/add_new_task_screen.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';
import 'package:task_manager1/ui/widgets/task_count_summary_card.dart';

import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {


    const NewTaskScreen({super.key,

    });
    @override
    State<NewTaskScreen> createState() => _NewTaskScreenState();
  }

  class _NewTaskScreenState extends State<NewTaskScreen> {


    final  _taskController=Get.find<NewTaskController>();
    final _taskCountController=Get.find<TaskCountController>();


   @override
  void initState() {
    // TODO: implement initState
    // _retrieveNewTask();
     _fetchNewTask();
     _fetchTaskCount();
    super.initState();
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        
        body: RefreshIndicator(
          color: Colors.green,
          onRefresh: ()async{

             await _taskCountController.taskSummaryCount(showLoading: false);
          },
          child: SingleChildScrollView(
            physics:AlwaysScrollableScrollPhysics(),
            child: Column(

              children: [
              // task summary count list

               GetBuilder<TaskCountController>(
                   builder: (controller){

                     return Visibility(
                       visible: controller.countProgress==false,
                       replacement: Padding(
                         padding: const EdgeInsets.symmetric(vertical: 15),
                         child: CenteredCircularProgressIndicator(),
                       ),
                       child: SizedBox(
                         height: 74,
                         child: ListView.separated(

                             scrollDirection: Axis.horizontal,
                             itemBuilder: (context,index){
                               TaskCountSummaryModel summaryModel=controller.taskCountList[index];

                               return TaskCountSummaryCard(title:summaryModel.id, count: summaryModel.sum);



                             },

                             separatorBuilder: (context,index){
                               return const SizedBox(width: 10);
                             },

                             itemCount:controller.taskCountList.length
                         ),

                       ),
                     );
                   }
               ),

                // all new task list

                GetBuilder<NewTaskController>(

                    builder: (controller){

                      return  Visibility(
                        visible: controller.taskProgress==false,
                        replacement: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CenteredCircularProgressIndicator()

                        ),

                        child:(controller.taskList.isEmpty)? SizedBox(
                            height: MediaQuery.of(context).size.height *0.6,
                            child: Center(child: Text("No New Task Found",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 20,color: Colors.red),),)

                        )
                            :ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){

                            List<TaskModel> reversedTaskList= controller.taskList.reversed.toList();

                            TaskModel task=reversedTaskList[index];

                            return TaskCard(
                              task:task,
                              taskType: TaskCategory.tNew,
                              onStatusUpdate: ()async {
                              //  _fetchNewTask();
                              await  controller.retrieveNewTask(showLoading: false);

                              await  Get.find<TaskCountController>().taskSummaryCount();

                              },

                              onDeleteTask: ()async{

                               await controller.retrieveNewTask(showLoading: false);
                               await Get.find<TaskCountController>().taskSummaryCount();
                              },
                            );
                          },
                          itemCount: controller.taskList.length,


                        ),
                      );

                    })


              ],
            ),
          ),
        ),
        
        floatingActionButton: FloatingActionButton(
            onPressed: _addNewTaskBtn,
          backgroundColor: Colors.green.shade400,
            child: Icon(Icons.add,
              color: Colors.white,
            )
        ),


      );
    }


    // retrieve tasks count(new-canceled-progress--complete)

    Future<void> _fetchTaskCount()async{

      bool success = await _taskCountController.taskSummaryCount();

      if(!success && mounted){
        showSnackbarMesssage(context, _taskCountController.errorMessage!);
      }


    }





    Future<void> _fetchNewTask() async {

      bool success = await _taskController.retrieveNewTask();
      if (!success && mounted) {
        showSnackbarMesssage(context, _taskController.errorMessage!);
      }
    }







    // go to add new task page
    void _addNewTaskBtn() async {

      Get.toNamed(AddNewTaskScreen.name)!.then((wasTaskAdded) {
        if (wasTaskAdded == true) {
          _taskController.retrieveNewTask(showLoading: false);
          _fetchTaskCount();

          if (mounted) {
            showSnackbarMesssage(context, "Task added Successfully");
          }
        } else {
          debugPrint("User returned without adding task");
        }
      });
    }





  }




