
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_pages.dart';
import '../../utils/responsive.dart';

class SignUpView extends StatelessWidget{
  SignUpView({Key? key}) : super(key: key);



  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final RxBool rememberMe = true.obs;

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.find<AuthController>();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          width:  Responsive.isMobile(context)
              ? width * 0.9
              : Responsive.isTablet(context)
              ? width * 0.6
              : width * 0.3,
          padding: const EdgeInsets.all(16),
          child: Obx(
                  ()=> Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create Account",
                    style: TextStyle(
                        fontSize: Responsive.isMobile(context) ? 24 : 32,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: "Email", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Password", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder()),
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                        value: rememberMe.value,
                        onChanged: (val) => rememberMe.value = val ?? true,
                      )),
                      const Text("Remember Me")
                    ],
                  ),
                  const SizedBox(height: 16),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _authController.isLoading.value
                        ? null
                        : () async{
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        Get.snackbar("Error", "Passwords do not match");
                        return;
                      }
                     await _authController.signUp(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          rememberMe: rememberMe.value);
                      if (!_authController.isLoading.value && _authController.isLoggedIn) {
                        Get.toNamed(Routes.login);
                      }
                    },
                    child: _authController.isLoading.value
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("Sign Up"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                      onPressed: () => Get.toNamed(Routes.login),
                      child: const Text("Already have an account? Sign In"))
                ],
              )
          ),
        ),
      ),
    );

  }


}