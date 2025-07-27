
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
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

  class _SplashScreenState extends State<SplashScreen> {


  
  // after 3 sec splash screen will move to next page
    Future<void> _moveToNextScreen() async{

    await  Future.delayed(Duration(seconds: 3));

     bool currentUser=await AuthController.isLogedIn();

     if(currentUser){
       Navigator.pushReplacementNamed(context, MainNavBarHolderScreen.name);
     }else{
       Navigator.pushReplacementNamed(context, SignInScreen.name);
     }


    }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moveToNextScreen();
  }
  
  
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(

        body:ScreenBackground(child: Center(child: SvgPicture.asset(AssetsPath.logo)))

      );
    }
  }
