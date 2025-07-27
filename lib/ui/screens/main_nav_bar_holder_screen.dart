import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager1/ui/screens/canceled_task_list_screen.dart';
import 'package:task_manager1/ui/screens/completed_task_list_screen.dart';
import 'package:task_manager1/ui/screens/new_task_list_screen.dart';
import 'package:task_manager1/ui/screens/pass_reset_screen.dart';
import 'package:task_manager1/ui/screens/progress_task_list_screen.dart';
import 'package:task_manager1/ui/utils/aseets_path.dart';

import '../widgets/tm_app_bar.dart';

class MainNavBarHolderScreen extends StatefulWidget {
  const MainNavBarHolderScreen({super.key});

  static const name = "/nav_bar_holder_screen";

  @override
  State<MainNavBarHolderScreen> createState() => _MainNavBarHolderScreenState();
}

class _MainNavBarHolderScreenState extends State<MainNavBarHolderScreen> {



  int _selectedIndex = 0;
  final List<Widget> _screens = [
   NewTaskScreen(),
    CompletedTaskListScreen(),
    CanceledTaskListScreen(),
    ProgressTaskListScreen()


  ];



  Future<void> _onRefresh() async{

    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: TmAppBar(),

          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
                color: Colors.green,
                onRefresh: _onRefresh,
                child: _screens[_selectedIndex]),
          ),

      bottomNavigationBar: NavigationBar(

        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Image.asset(AssetsPath.newTask,
          height: 24,
          width: 24,
          ),
              selectedIcon:Image.asset(AssetsPath.newTask,height: 24,width: 24,color: Colors.red,),
              label: "New tasks")
          ,

          NavigationDestination(icon: Image.asset(AssetsPath.completed2,
            height: 24,
              width: 24,
          ),
              label: "Completed",

            selectedIcon: Image.asset(AssetsPath.completed2,height: 24,width: 24,
            color: Colors.red,

            ),



          ),

          NavigationDestination(icon: Image.asset(AssetsPath.canceled2,
          height: 24,
              width: 24,
          ),
              label: "Canceled",
            selectedIcon: Image.asset(AssetsPath.canceled2,height: 24,width: 24,color: Colors.red,),
          ),

          NavigationDestination(icon: Image.asset(AssetsPath.progress,
              height: 24,
              width: 24,
           ),
              label: "Progress",
            selectedIcon: Image.asset(AssetsPath.progress,height: 24,width: 24,color: Colors.red,),
          ),
        ],
      ),
    );
  }
}


