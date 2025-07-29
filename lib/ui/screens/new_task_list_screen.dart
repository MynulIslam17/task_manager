  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager1/data/models/task_count_summary_model.dart';
import 'package:task_manager1/data/models/task_model.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/screens/add_new_task_screen.dart';
import 'package:task_manager1/ui/utils/aseets_path.dart';
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


     bool _newTaskListShowingProgress=false;

     bool _tasksCountProgress=false;

     List<TaskModel>taskList=[];
     List<TaskCountSummaryModel>tasksSummaryList=[];

   @override
  void initState() {
    // TODO: implement initState
     _retrieveNewTask();
     _retrieveTaskCount();
    super.initState();
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        
        body: RefreshIndicator(
          color: Colors.green,
          onRefresh: ()async{

            await _retrieveTaskCount(showLoading: false);
            await _retrieveNewTask(showLoading: false);
          },
          child: SingleChildScrollView(
            physics:AlwaysScrollableScrollPhysics(),
            child: Column(

              children: [
              // task summary count list

               Visibility(
                 visible: _tasksCountProgress==false,
                 replacement: Padding(
                   padding: const EdgeInsets.symmetric(vertical: 15),
                   child: CenteredCircularProgressIndicator(),
                 ),
                 child: SizedBox(
                   height: 74,
                   child: ListView.separated(

                     scrollDirection: Axis.horizontal,
                       itemBuilder: (context,index){
                          TaskCountSummaryModel summaryModel=tasksSummaryList[index] ;

                       return TaskCountSummaryCard(title:summaryModel.id, count: summaryModel.sum);



                   },

                       separatorBuilder: (context,index){
                         return const SizedBox(width: 10);
                       },

                       itemCount:tasksSummaryList.length),

                 ),
               ),

                // all new task list
                Visibility(
                  visible: _newTaskListShowingProgress==false,
                  replacement: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: CenteredCircularProgressIndicator()

                  ),

                  child:(taskList.isEmpty)? SizedBox(
                      height: MediaQuery.of(context).size.height *0.6,
                      child: Center(child: Text("No New Task Found",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 20,color: Colors.red),),))
                      :ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){

                      TaskModel task=taskList[index];

                    return TaskCard(
                        task:task,
                        taskType: TaskCategory.tNew,
                        onStatusUpdate: () {
                            _retrieveNewTask(showLoading: false);
                          _retrieveTaskCount();

                        },

                      onDeleteTask: ()async{
                        await  _retrieveNewTask();
                        await  _retrieveTaskCount();
                      },
                    );
                  },
                    itemCount: taskList.length,


                  ),
                )


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

     Future<void> _retrieveTaskCount({ bool showLoading=true }) async{


       if(showLoading){ // loading visible or not depend on the flag

         setState(() {
           _tasksCountProgress=true;
         });


       }


       
       
        NetworkResponse response =await NetworkCaller.getRequest(ApiUrls.taskCountUrl);


       if(showLoading){
         if(mounted){

           setState(() {
             _tasksCountProgress=false;
           });

         }

       }

       if(response.success){

            List<TaskCountSummaryModel> list=[];

          final List<dynamic>data=response.body?["data"];

          for(Map<String,dynamic> tasksCount in data){
            list.add(TaskCountSummaryModel.fromJsom(tasksCount));
          }

          if(mounted){
            setState(() {
              tasksSummaryList=list;
            });
          }



       }else{

         if(mounted){
           showSnackbarMesssage(context,response.errorMsg!);
         }



       }



     }



   // retrieve all new task list
    Future<void> _retrieveNewTask({ bool showLoading = true} ) async{


      if(showLoading){
        setState(() {
          _newTaskListShowingProgress=true;
        });
      }


      NetworkResponse response=await NetworkCaller.getRequest(ApiUrls.newTaskListUrl);


      if(showLoading){
        setState(() {
          _newTaskListShowingProgress=false;
        });
      }


     if(response.success){

       List<TaskModel> newList=[];

        List<dynamic>dataList=response.body?["data"];

        for(Map<String,dynamic> task in dataList){

                newList.add(TaskModel.fromJson(task));
        }




       setState(() {
         taskList=newList;

       });


     }else{

       if(mounted) {
         showSnackbarMesssage(context, response.errorMsg!);
       }

     }




    }



    // go to add new task page
    void _addNewTaskBtn() async {

      Navigator.pushNamed(context, AddNewTaskScreen.name).then((wasTaskAdded){

        if(wasTaskAdded==true){
          _retrieveNewTask() ;
          _retrieveTaskCount();

          if(mounted){
            showSnackbarMesssage(context, "Task added Successfully");

          }


        }else{
          debugPrint("User returned without adding task");
        }


      });

    }




  }




