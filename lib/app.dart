
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager1/ui/screens/add_new_task_screen.dart';
import 'package:task_manager1/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager1/ui/screens/pass_reset_screen.dart';
import 'package:task_manager1/ui/screens/pin_verify_screen.dart';
import 'package:task_manager1/ui/screens/profile_screen.dart';
import 'package:task_manager1/ui/screens/sign_in_screen.dart';
import 'package:task_manager1/ui/screens/sign_up_screen.dart';
import 'package:task_manager1/ui/screens/verify_email_screen.dart';
import 'ui/screens/splash_screen.dart';



class TaskManger extends StatelessWidget{
  const TaskManger({super.key});

  static GlobalKey<NavigatorState> navigator=GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
     // home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator,
      theme: ThemeData(
        colorSchemeSeed:Colors.red,


        textTheme:TextTheme(
          titleMedium: TextStyle(
            fontSize: 28,
             fontWeight: FontWeight.w700
          ),

          titleSmall: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.grey
          )


        ),

        inputDecorationTheme: InputDecorationTheme(

            hintStyle: TextStyle(color:Colors.grey),
            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide:BorderSide.none
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none
            ),

            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none
            ),

            errorBorder: OutlineInputBorder(
                borderSide: BorderSide.none
            )


        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(

                  fixedSize: Size.fromWidth(double.maxFinite),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                  ),



          )


        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
           foregroundColor: Colors.grey
          ),

        )

      ),

      initialRoute: SplashScreen.name,

      routes: {

        SplashScreen.name : (context) => SplashScreen(),
        SignInScreen.name : (context)=> SignInScreen(),
        SignUpScreen.name : (context)=>SignUpScreen(),
        VerifyEmailScreen.name : (context)=> VerifyEmailScreen(),
       //  PinVerifyScreen.name : (context)=>PinVerifyScreen(),
       // PassResetScreen.name : (context)=> PassResetScreen(),
        MainNavBarHolderScreen.name : (context)=>MainNavBarHolderScreen(),
        AddNewTaskScreen.name : (context)=>AddNewTaskScreen(),
        ProfileScreen.name : (context)=>ProfileScreen()

      },

    );
  }


}