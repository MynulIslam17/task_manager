import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager1/controllers/signin_controller.dart';
import 'package:task_manager1/data/models/userModel.dart';
import 'package:task_manager1/data/service/auth_controller.dart';
import 'package:task_manager1/data/service/network_caller.dart';
import 'package:task_manager1/data/urls/api_urls.dart';
import 'package:task_manager1/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager1/ui/screens/sign_up_screen.dart';
import 'package:task_manager1/ui/screens/verify_email_screen.dart';
import 'package:task_manager1/ui/widgets/circular_progress_indicator.dart';
import '../widgets/password_field.dart';
import '../widgets/screen_background.dart';
import '../widgets/snackbar.dart';

class SignInScreen extends StatefulWidget {
  static const String name = "/sign_in_screen";

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passTEController = TextEditingController();
  bool _obscureText = true;

   final SignInController _signController=SignInController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "Get Started With ",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      if (!EmailValidator.validate(value)) {
                        return "Invalid Email";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  const SizedBox(height: 10),
                  PasswordField(
                    passTEController: _passTEController,
                    tapToSee: _tapToSeePassword,
                    obscureText: _obscureText,
                    textHint: "password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "password is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  GetBuilder(
                    init: _signController,
                    builder: (controller) {
                      return Visibility(
                        visible: controller.signInProgress == false,
                        replacement: const CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: _onTapSignInButton,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: _forgetPassText,
                          child: const Text("Forget Password ?"),
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account ? ",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _tapSignup,
                                text: "Sign up",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _tapToSeePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _forgetPassText() {
    Get.to(() => const VerifyEmailScreen());
  }

  void _tapSignup() {
    Get.toNamed(SignUpScreen.name);
  }

  void _onTapSignInButton() async {

    if (_formKey.currentState!.validate()) {


      final isSuccess = await _signController.signIn(
        email: _emailTEController.text.trim(),
        password: _passTEController.text,
      );

      if (isSuccess) {
        Get.offNamed(MainNavBarHolderScreen.name);
      } else {
        if (mounted) {
          showSnackbarMesssage(context, _signController.errorMessage ?? "Something went wrong");
        }
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passTEController.dispose();
    super.dispose();
  }
}
