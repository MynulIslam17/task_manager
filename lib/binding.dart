
  import 'package:get/get.dart';
import 'package:task_manager1/controllers/completed_task_controller.dart';
import 'package:task_manager1/controllers/new_task_controller.dart';
import 'package:task_manager1/controllers/taskCount_controller.dart';

class ControllerBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.put(NewTaskController());
    Get.put(TaskCountController());
    Get.put(CompletedTaskController());

  }

}