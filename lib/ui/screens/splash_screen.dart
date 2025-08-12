
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager1/data/service/auth_controller.dart';
import 'package:task_manager1/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager1/ui/screens/sign_in_screen.dart';
import 'package:task_manager1/ui/utils/aseets_path.dart';
import 'package:task_manager1/ui/widgets/screen_background.dart';




class SplashScreen extends StatefulWidget {
  static const String name="/splash_screen";
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
  }

  class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

      double _opacity=0;
      late final AnimationController _animController;



  // after 3 sec splash screen will move to next page
    Future<void> _moveToNextScreen() async{

      _animController.addStatusListener((status)async{

        if(status==AnimationStatus.completed){

          try{

            bool currentUser=await AuthController.isLogedIn();

            if(currentUser){
              Get.offNamed(MainNavBarHolderScreen.name);
            }else{
              Get.offNamed(SignInScreen.name);
            }


          }catch (e){
            print("Error checking login or navigating: $e");
          }

        }

      });




    }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animController=AnimationController(vsync: this);

    Future.delayed(Duration(milliseconds: 300),(){

      setState(() {
        _opacity=1;
      });

    });

    _moveToNextScreen();
  }



    @override
    Widget build(BuildContext context) {
      return Scaffold(

       body:ScreenBackground(child:
          Center(
            child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [



              Lottie.asset(AssetsPath.taskAnim,

                  controller: _animController,
                  height:230,
                  width: double.maxFinite,
                onLoaded: (composition) {
                  _animController
                    ..duration = composition.duration * (1 / 1.5) // ≈ 1.2x speed
                    ..forward();
          },
              ),

              AnimatedOpacity(opacity: _opacity,
                duration: Duration(seconds: 1),
                child: Image.asset(AssetsPath.appNameImage,height: 90,width: 400,color: Colors.indigo,),
              ),


            ],

                   ),
          )

       ),

      );
    }
  }
