
    import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/screen_background.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';
import 'package:task_manager1/ui/widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {

      static const name="add_new_task_screen";

      const AddNewTaskScreen({super.key});

      @override
      State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
    }

    class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

   bool  _newTaskProgress=false;

    final _formKey=GlobalKey<FormState>();
    final TextEditingController _titleTEController=TextEditingController();
    final TextEditingController _descriptionTEController=TextEditingController();

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: TmAppBar(),
          body: ScreenBackground(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                        const SizedBox(height: 40,),
                      Text("Add New Task",style: TextTheme.of(context).titleMedium,),
                      const SizedBox(height: 10,),

                      TextFormField(
                        controller: _titleTEController,
                     textInputAction: TextInputAction.next,
                     validator: (value){
                          if(value == null || value.isEmpty){
                            return "title is required";
                          }
                          return null ;
                     },
                     decoration: InputDecoration(
                       hintText: "title"
                     ),
                      ),

                      const SizedBox(height: 10,),

                      TextFormField(
                        controller: _descriptionTEController,
                        textInputAction: TextInputAction.done,
                        validator: (value){
                          if(value== null || value.isEmpty){
                            return "description is required";
                          }
                          return null ;
                        },
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Description",

                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Visibility(
                         visible: _newTaskProgress==false,
                        replacement:CenteredCircularProgressIndicator(),
                        child: ElevatedButton(onPressed:_submitNewTaskBtn ,
                            child: Icon(Icons.arrow_circle_right_outlined)
                        ),
                      )


                    ],
                  ),
                ),
              )
          
          ),
        );
      }


      void _submitNewTaskBtn() async{

        if(_formKey.currentState!.validate()){


          setState(() {
            _newTaskProgress=true;
          });

          Map<String,dynamic>taskInfo={
            "title":_titleTEController.text.trim(),
            "description": _descriptionTEController.text.trim(),
            "status":"New"
          };

          NetworkResponse response=await NetworkCaller.postRequest(url: ApiUrls.createTaskUrl,body: taskInfo);

          setState(() {
            _newTaskProgress=false;
          });

          if(response.success){

            _clearTextFiled();

            showSnackbarMesssage(context, "Task added Successfully");

          }else{
            showSnackbarMesssage(context, response.errorMsg!);
          }



        }


      }

      // clear textFiled
   void _clearTextFiled(){

        _titleTEController.clear();
        _descriptionTEController.clear();
   }


      @override
  void dispose() {
    // TODO: implement dispose
        _titleTEController.dispose();
        _descriptionTEController.dispose();
    super.dispose();
  }



    }
