
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_pages.dart';
import '../../utils/responsive.dart';

class HomePage extends StatelessWidget{
  final AuthController authController = Get.find<AuthController>();

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.signOut();
              Get.offAllNamed(Routes.login);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.05),
            Obx(() {
              final userEmail = authController.firebaseUser.value?.email ?? '';
              return Text(
                "Welcome, $userEmail",
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 20 : 32,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
            SizedBox(height: size.height * 0.02),
            const Text(
              "This is your secure home screen.",
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh User Info"),
              onPressed: () async {
                // await authController.refreshUser();
              },
            ),
          ],
        ),
      ),
    );

  }

}