import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager1/app.dart';
import 'package:task_manager1/data/models/task_model.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';

import '../utils/aseets_path.dart';

enum TaskCategory {tNew,Completed,Canceled,Progress} // top level enum

class TaskCard extends StatefulWidget {

  final TaskCategory taskType;
   final TaskModel task;
   final VoidCallback onStatusUpdate;
   final VoidCallback onDeleteTask;



  const TaskCard({
    super.key,
    required this.task,
    required this.taskType,
    required this.onStatusUpdate,
    required this.onDeleteTask


  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  bool _statusChangeProgress=false;



  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),

      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.task.title),
            const SizedBox(height: 3,),
            Text(widget.task.description),
            const SizedBox(height: 9,),
            Text(widget.task.createDate),

            Row(
              children: [

                Chip(label:Text(_chipText() ,style: TextStyle(color:Colors.white,fontSize: 12),),
                  backgroundColor: _getChipColor(),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),

                Spacer(),

                Visibility(
                  visible: _statusChangeProgress==false,
                  replacement: SizedBox(
                      height: 25,
                      width: 25,
                      child: CenteredCircularProgressIndicator()),
                  child: IconButton(onPressed:_editTaskBtn,
                      icon:Image.asset(AssetsPath.edit,height: 20,width: 20,)
                  ),
                ),

                IconButton(onPressed:(){
                  _deleteTaskBtn(context);
                },
                    icon: Image.asset(AssetsPath.delete,height: 20,width: 20,)
                )


              ],
            )

          ],
        ),
      ),
    );
  }

  Color _getChipColor(){
   //  if(taskType== TaskCategory.tNew){
   //   return Colors.green;
   // }else if(taskType==TaskCategory.Completed){
   //   return Colors.purple;
   // }else if(taskType==TaskCategory.Canceled){
   //   return Colors.red;
   // }else{
   //   return Colors.blue;
   // }

    switch(widget.taskType){

      case TaskCategory.tNew :
        return Colors.blue;

      case TaskCategory.Completed :
        return Colors.green;
      case TaskCategory.Canceled :
        return Colors.red;
      case TaskCategory.Progress :
        return Colors.purple;


    }



  }

  String _chipText(){

    switch(widget.taskType){

      case TaskCategory.tNew:
        return "New";
      case TaskCategory.Canceled :
        return "Canceled";
      case TaskCategory.Progress :
        return "Progress";
      case TaskCategory.Completed :
        return "Completed";

    }


  }

  // show dialog for edit task
  void _editTaskBtn(){

   showDialog(context: context, builder: (context){

     return AlertDialog(
       title: Text("Select Status ",style: TextTheme.of(context).titleMedium,),
       content:Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           
           ListTile(
             title: Text("New",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 17),),
             trailing:_getTaskStatusTrailing(TaskCategory.tNew),
            
             onTap: (){

                if(_tapOnCurrentStatus(TaskCategory.tNew)){
                  return;
                }

               _changeTaskStatus("New");
             },
           ),
           ListTile(
             title: Text("Completed",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 17),),
                trailing: _getTaskStatusTrailing(TaskCategory.Completed),
                selectedTileColor: Colors.grey,
               onTap: (){

               if(_tapOnCurrentStatus(TaskCategory.Completed)){
                 return;
               }

             _changeTaskStatus("Completed");
               }
           ),
           ListTile(
             title: Text("Canceled",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 17),),
             trailing: _getTaskStatusTrailing(TaskCategory.Canceled),
             onTap: (){

               if(_tapOnCurrentStatus(TaskCategory.Canceled)){
                 return;
               }
               _changeTaskStatus("Canceled");

             },
           ),
           ListTile(
             title: Text("Progress",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 17),),
             trailing: _getTaskStatusTrailing(TaskCategory.Progress),
             onTap: (){

               if(_tapOnCurrentStatus(TaskCategory.Progress)){
                 return ;
               }
               _changeTaskStatus("Progress");

             },
           ),

           
           
         ],

       ),

     );
   });

  }

  // selected status  check
  Widget ? _getTaskStatusTrailing(TaskCategory task){
    return  (widget.taskType==task) ? Icon(Icons.check) :  null;
  }


  // check if tap on current status
     bool _tapOnCurrentStatus(TaskCategory taskType){

      if(widget.taskType==taskType){
        return  true;
      }else{
        return  false;
      }


     }



  // change taskStatus

  Future<void> _changeTaskStatus(String status) async{

    Navigator.pop(context); // close the dialog

  setState(() {
    _statusChangeProgress=true;
  });


     NetworkResponse response=await NetworkCaller.getRequest(ApiUrls.updateTaskStatusUrl(id: widget.task.id, status: status));

  if(mounted){
    setState(() {
      _statusChangeProgress=false;
    });
  }

   if(response.success){

     widget.onStatusUpdate();



   }else{

     if(mounted){
       showSnackbarMesssage(context, response.errorMsg!);
     }

   }





  }



  // show dialog when delete task
  void _deleteTaskBtn(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isDeleting = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: const [
                  Icon(Icons.dangerous, color: Colors.red),
                  SizedBox(width: 4),
                  Text("Confirm delete", style: TextStyle(fontSize: 17)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(thickness: 1, color: Colors.black.withOpacity(0.1)),
                  const Text("Are you sure you want to delete this task?"),
                  const SizedBox(height: 20),
                  Divider(color: Colors.black.withOpacity(0.1)),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },

                          child: Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(100, 40),
                          backgroundColor: Colors.green,
                        ),

                      ),



                      Visibility(
                        visible: isDeleting==false,
                        replacement: const CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed:()async{
                            setState(() {
                              isDeleting = true;
                            });

                            await _deleteTask();

                            if(!mounted){
                              return;
                            }

                            setState((){
                              isDeleting=false;

                            });

                            Navigator.pop(context);

                          },
                          child: const Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(100, 40),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),


                    ],
                  )

                ],
              ),
            );
          },
        );
      },
    );
  }



  Future<void> _deleteTask() async {


    NetworkResponse response=await NetworkCaller.getRequest(ApiUrls.deleteTaskUrl(widget.task.id));
    
     if(!mounted){
       return;
     }
    
      if(response.success){
        
        showSnackbarMesssage(context, "Task deleted successfully. ");

        widget.onDeleteTask();

      }else{
        showSnackbarMesssage(context, response.errorMsg ?? "Delete failed.");
      }

  } // this method for delete task



}