import 'dart:convert';
import 'package:get/get.dart';
import '../data/models/userModel.dart';
import '../data/service/auth_controller.dart';
import '../data/service/network_caller.dart';
import '../data/urls/api_urls.dart';

class ProfileUpdateController extends GetxController {
  bool _inProgress = false;
  String? errorMassage;

  bool get inProgress => _inProgress;

  Future<bool> updateProfile(Map<String, dynamic> updateData, List<int>? imageBytes) async {
    _inProgress = true;
    update(); // for GetBuilder if used

    final response = await NetworkCaller.postRequest(
      url: ApiUrls.profileUpdateUrl,
      body: updateData,
    );

    _inProgress = false;
    update(); // again update ui

    if (response.success) {
      // Update local AuthController data
      UserModel updatedUser = UserModel(
        id: AuthController.userModel!.id,
        email: AuthController.userModel!.email, // email can't be changed
        firstName: updateData["firstName"],
        lastName: updateData["lastName"],
        mobile: updateData["mobile"],
        photo: imageBytes == null
            ? AuthController.userModel!.photo // if no image selected then add previous one
            : base64Encode(imageBytes),// if selected then convert to string
      );

      await AuthController.updateData( updatedUser);
      update();
      return true;
    } else {
      errorMassage = response.errorMsg ?? "Profile update failed.";
      update();
      return false;
    }
  }
}
