   import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager1/data/models/task_model.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';
import 'package:task_manager1/ui/widgets/task_card.dart';

class CanceledTaskListScreen extends StatefulWidget {
     const CanceledTaskListScreen({super.key});

     @override
     State<CanceledTaskListScreen> createState() => _CanceledTaskListScreenState();
   }

   class _CanceledTaskListScreenState extends State<CanceledTaskListScreen> {

    bool _canceledTaskListProgress=false;
    List<TaskModel> canceledTaskList=[];

    @override
  void initState() {
    // TODO: implement initState
      _canceledTaskRetrieve();
    super.initState();
  }


     @override
     Widget build(BuildContext context) {
       return Visibility(
         visible: _canceledTaskListProgress==false,
         replacement: Padding(
           padding: const EdgeInsets.symmetric(vertical: 10),
           child: CenteredCircularProgressIndicator(),
         ),
         child:(canceledTaskList.isEmpty) ? Center(child: Text("No Completed Task Found",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 20,color:Colors.red),))
             : ListView.builder(itemBuilder: (context,index){
          TaskModel task= canceledTaskList[index];
           return TaskCard(task: task, taskType: TaskCategory.Canceled,
             onStatusUpdate: (){
             _canceledTaskRetrieve();
             },

             onDeleteTask: ()async{

             await _canceledTaskRetrieve();

             },

           );
         },
           itemCount: canceledTaskList.length,


         ),
       );
     }



     Future<void> _canceledTaskRetrieve() async{

      setState(() {
        _canceledTaskListProgress=true;
      });



          NetworkResponse response =await NetworkCaller.getRequest(ApiUrls.canceledTaskListUrl);


          setState(() {
            _canceledTaskListProgress=false;
          });


          if(response.success){

            List<TaskModel> list=[];
            final List<dynamic>data=response.body?["data"];

            for(Map<String,dynamic>task in data){
              list.add(TaskModel.fromJson(task));
            }


            setState(() {
              canceledTaskList=list;
            });

          }else{
            showSnackbarMesssage(context, response.errorMsg!);
          }


     }


   }
