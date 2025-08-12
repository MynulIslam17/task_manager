import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager1/data/models/userModel.dart';
import 'package:task_manager1/data/service/auth_controller.dart';
import 'package:task_manager1/ui/screens/profile_screen.dart';
import 'package:task_manager1/ui/screens/sign_in_screen.dart';

import '../../controllers/profile_update_controller.dart';

class TmAppBar extends StatefulWidget implements PreferredSizeWidget{
  const TmAppBar({
    super.key,
  });

  @override
  State<TmAppBar> createState() => _TmAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TmAppBarState extends State<TmAppBar> {

  final _profileUpdateController=Get.find<ProfileUpdateController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileUpdateController>(
        builder: (controller){
          return AppBar(

            backgroundColor: Colors.green.shade400,

            title: InkWell(
              onTap:_onTapAppbar ,


              child: Row(

                children: [
                  CircleAvatar(

                      backgroundImage:AuthController.userModel!.photo == null ? null
                          : MemoryImage(base64Decode(AuthController.userModel!.photo!))


                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text("${AuthController.userModel?.firstName} ${AuthController.userModel?.lastName}",maxLines: 1,style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis
                        ) ,),
                        Text("${AuthController.userModel?.email}",maxLines: 1,style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis
                        ),)
                      ],
                    ),
                  ),

                  // logout btn can be here also
                  // IconButton(onPressed: (){},
                  //     icon: Icon(Icons.logout))
                ],
              ),
            ),

            actions: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(onPressed:_doLogout ,
                      icon: Icon(Icons.logout))
              )
            ],


          );
        }
    );
  }

  // click event on appbar to go profile
   Future<void> _onTapAppbar() async {

    final currentRoute=ModalRoute.of(context)?.settings.name;

    if(currentRoute!=ProfileScreen.name){
      await Future.delayed(Duration(milliseconds:200));
      Navigator.pushNamed(context, ProfileScreen.name);
    }

   // Navigator.pushNamed(context,ProfileScreen.name );
  }

  // click  event for logout
   void _doLogout(){
      
    showDialog(context: context, 
        builder: (context){
      
      return AlertDialog(

        
        title: Text("Confirm logout",style: TextStyle(fontSize: 17),),
        content: Text("Are you sure you want to logout ?"),
        
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          },
              child: Text("No"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue
            ),
          ),
          TextButton(onPressed: ()async{

             AuthController.clearData();

            Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate)=>false);


          },
              child: Text("Yes"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue
            ),
          )
        ],
        
      );
      
        });

    
   }


}