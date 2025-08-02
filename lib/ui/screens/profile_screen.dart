
  import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager1/controllers/profile_update_controller.dart';
import 'package:task_manager1/data/models/userModel.dart';
import 'package:task_manager1/data/service/auth_controller.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/utils/aseets_path.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager1/ui/widgets/password_field.dart';
import 'package:task_manager1/ui/widgets/screen_background.dart';
import 'package:task_manager1/ui/widgets/snackbar.dart';
import 'package:task_manager1/ui/widgets/tm_app_bar.dart';

class ProfileScreen extends StatefulWidget {

  static const String name="profile_screen";
    const ProfileScreen({super.key});

    @override
    State<ProfileScreen> createState() => _ProfileScreenState();
  }

  class _ProfileScreenState extends State<ProfileScreen> {

  bool _obsecureText=true;
  // bool _profileUpdateProgress=false;
  final _profileUpdateController=Get.find<ProfileUpdateController>();

  final _formKey=GlobalKey<FormState>();
  final  TextEditingController _emailTEController=TextEditingController();
 final TextEditingController _fNameTEController=TextEditingController();
 final TextEditingController _lNTEController=TextEditingController();
 final TextEditingController _mobileTEController=TextEditingController();
 final TextEditingController _passwordTEController=TextEditingController();


 final ImagePicker picker=ImagePicker();
 File ? _selectedImage;



 @override
  void initState() {
    // TODO: implement initState
   _getUserInfoFromAuth(); // fetch userInfo that previously saved on auth

    super.initState();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(

        appBar: TmAppBar(),

        body:SafeArea(
          child: ScreenBackground(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                       const SizedBox(height: 20,),

                        Text("Update Profile",style: Theme.of(context).textTheme.titleMedium,),
                        const SizedBox(height: 10,),


                      Center(
                        child: Stack(
                          children: [

                            CircleAvatar(
                              radius: 60,
                             backgroundImage: (_selectedImage != null)
                                 ? FileImage(_selectedImage!)
                                 : (AuthController.userModel?.photo == null || AuthController.userModel!.photo!.isEmpty)
                                 ?  const AssetImage(AssetsPath.userDefaultDp)
                                 : MemoryImage(base64Decode(AuthController.userModel!.photo!)),


                              backgroundColor: Colors.white,

                            ),


                            Positioned(
                              bottom: 0,
                                right: 0,
                                child: ElevatedButton(
                                  onPressed:(){
                                    _showImageBottomSheet(context);
                                  },

                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(20, 20),
                                    shape: CircleBorder(),
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white
                                  ),
                                  child: Icon(Icons.edit,size: 20,),
                                )

                            )



                          ],
                        ),
                      ),





                        const SizedBox(height: 10,),



                    TextFormField(
                      controller: _emailTEController,
                      textInputAction: TextInputAction.next,
                      enabled:false,

                    ),
                        const SizedBox(height: 10,),

                        TextFormField(
                          controller: _fNameTEController,
                          textInputAction: TextInputAction.next,
                      validator: (value){
                            if(value==null || value.isEmpty){
                              return "first name is required";
                            }
                            return null ;
                      },
                      decoration: InputDecoration(
                        hintText: "First Name"
                      ),
                    ),

                         const SizedBox(height: 10,),

                         TextFormField(
                           controller: _lNTEController,
                             textInputAction: TextInputAction.next,
                             validator: (value){
                               if(value==null || value.isEmpty){
                                 return "last name is required";
                               }
                               return null ;
                             },
                      decoration: InputDecoration(
                        hintText: "Last Name"
                      ),
                    ),
                           const SizedBox(height: 10,),

                           TextFormField(
                             controller: _mobileTEController,
                            keyboardType:TextInputType.number,
                           textInputAction: TextInputAction.next,
                               validator: (value){
                                 if(value==null || value.isEmpty){
                                   return "mobile is required";
                                 }
                                 return null ;
                               },
                      decoration: InputDecoration(
                        hintText: "Mobile"
                      ),
                    ),

                              const SizedBox(height: 10,),


                        PasswordField(passTEController: _passwordTEController, tapToSee: _togglePassVisibility, obscureText: _obsecureText, textHint: "Password",
                          validator: (value) {
                            int length = value?.length ?? 0;
                            if (length > 0 &&  length<=6){
                              return "Password must be at least 7 characters long";
                            }

                            return null;


                          }


                          ),



                        const SizedBox(height: 20,),


                        GetBuilder<ProfileUpdateController>(
                            builder: (controller){
                              return   Visibility(
                                visible: controller.inProgress==false,
                                replacement: CenteredCircularProgressIndicator(),
                                child: ElevatedButton(onPressed: _updateSubmitBtn,
                                    child: Icon(Icons.arrow_circle_right_outlined)),
                              );

                            }),


                        const SizedBox(height: 22,)



                      ],
                    ),
                  ),
                ),
              )
          ),
        ),

      );
    }


 // method for adding image to select image
  Future<void> _addImage(ImageSource source ) async{

    Navigator.pop(context);

    final XFile? pickedImage = await picker.pickImage(source: source);

    if(pickedImage!=null){
      setState(() {
        _selectedImage=File(pickedImage.path);

      });

    }

  }


  // bottomssheet that provide option to select image (gallery/camera)
    void _showImageBottomSheet(BuildContext context){

      showModalBottomSheet(context: (context), builder: (context){


        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             const SizedBox(height: 10,),
            Text("Pick profile picture",style: TextTheme.of(context).titleMedium?.copyWith(fontSize: 21),),
            const SizedBox(height:20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [

         // for taking picture then select it
                Card(
                  elevation: 10,
                  clipBehavior: Clip.antiAlias,
                  shape:CircleBorder(),
                  child: InkWell(
                    onTap: (){
                      _addImage(ImageSource.camera);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(AssetsPath.cameraImage,width: 50,height: 50,fit: BoxFit.cover,),
                    ),
                  ),

                ),



            // image select from gallery
                Card(
                  elevation: 10,
                  clipBehavior: Clip.antiAlias,
                shape: CircleBorder(),
              child: InkWell(
                onTap: (){
                  _addImage(ImageSource.gallery);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(AssetsPath.galleryImage
                        ,height: 50,width: 50,fit: BoxFit.cover,),
                ),
              ),
                ),




              ],
            ),

            const SizedBox(height: 40,)


          ],

        );

      });


    }


 // reverse  obsecure value
    void _togglePassVisibility(){

      setState(() {
        _obsecureText=!_obsecureText;
      });

    }

  //  click event for submit button
    void _updateSubmitBtn() async{
      if(_formKey.currentState!.validate()){

        List<int>? imageBytes;


        Map<String,dynamic>profileUpdateInfo={
          // email cant be change once added so this filed missing
          "firstName":_fNameTEController.text.trim(),
          "lastName":_lNTEController.text.trim(),
          "mobile":_mobileTEController.text.trim(),
        };

        // if available then  add two optional filed

        if(_passwordTEController.text.isNotEmpty){ // if new pass add

          profileUpdateInfo["password"]=_passwordTEController.text;
        }

        if(_selectedImage!=null){ // if any image selected


           imageBytes   =await _selectedImage!.readAsBytes();

            String imageString = base64Encode(imageBytes);

            profileUpdateInfo["photo"]=imageString;

        }



        bool success=await _profileUpdateController.updateProfile(profileUpdateInfo,imageBytes);



        if(success){ // if profile updated success
          _passwordTEController.clear();

        }else{
          if(mounted){
            showSnackbarMesssage(context,_profileUpdateController.errorMassage!);
          }
        }





      }
    }


   // retrieve new save data if profile update then execute
    Future<void> _retrieveUserDetails() async{


        NetworkResponse response  =await NetworkCaller.getRequest(ApiUrls.profileDetailsUrl);

        if(response.success){

          List<dynamic> data=response.body?["data"];

          Map<String,dynamic> map= data[0];

          UserModel updatedModel=UserModel.fromJson(map);

         await  AuthController.saveDataAndToken(AuthController.Token!, updatedModel);


        }else{

          if(mounted){

            showSnackbarMesssage(context, response.errorMsg!);
          }
        }


    }



    void _getUserInfoFromAuth(){

      _emailTEController.text=AuthController.userModel?.email ?? "";
      _fNameTEController.text=AuthController.userModel ?.firstName ?? "" ;
      _lNTEController.text=AuthController.userModel?.lastName ?? "";
      _mobileTEController.text=AuthController.userModel?.mobile ?? "";


    }



    @override
  void dispose() {
    // TODO: implement dispose
      _emailTEController.dispose();
      _fNameTEController.dispose();
      _lNTEController.dispose();
      _mobileTEController.dispose();
      _passwordTEController.dispose();
    super.dispose();
  }


  }
