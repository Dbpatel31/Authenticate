
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_pages.dart';
import '../../utils/responsive.dart';

class LoginPage extends StatelessWidget{

  final AuthController _authController= Get.find<AuthController>();


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool rememberMe = true.obs;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          width: Responsive.isMobile(context)? width*0.9 : Responsive.isTablet(context)? width*0.6: width*0.3,
          padding: const EdgeInsets.all(16),
          child: Obx(()=> Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Back",
                style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 24 : 32,
                    fontWeight: FontWeight.bold),
              ),
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
              ElevatedButton(
                onPressed: _authController.isLoading.value
                    ? null
                    :() async {
                  await _authController.signIn(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    rememberMe: rememberMe.value,
                  );


                  if (_authController.isLoggedIn) {
                    Get.offAllNamed(Routes.home);
                  }
                },
                child: _authController.isLoading.value
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text("Sign In"),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
              ),
              const SizedBox(height: 12),
              TextButton(
                  onPressed: () => Get.toNamed(Routes.signup),
                  child: const Text("Don't have an account? Sign Up")),

              const SizedBox(height: 12),
              TextButton(
                  onPressed: () => Get.toNamed(Routes.home),
                  child: const Text("Go To Next"))
            ],
          )

          ),
        ),
      ),
    );
  }

}