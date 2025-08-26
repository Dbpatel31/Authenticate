import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:authenticate/routes/app_pages.dart';
import 'package:authenticate/views/auth/sign_up_view.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'app_bindings.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();



  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppBindings.initServices();

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // FlutterError.onError= (details){
  //   FlutterError.dumpErrorToConsole(details);
  //   FirebaseCrashlytics.instance.recordFlutterError(details);
  // };
  //
  // PlatformDispatcher.instance.onError= (error, stack){
  //   print("PlatformDispatcher Error: $error");
  //
  //   FirebaseCrashlytics.instance.recordError(
  //     error,
  //     stack,
  //     reason: "PlatformDispatcher Error",
  //   );
  //   return true;
  // };

  runZonedGuarded(() async{

    runApp( MyApp());
  }, (error, stack){
    print("ZonedGuarded Error: $error");
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: "ZonedGuarded Async Error",
    );
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      initialBinding: AppBindings(),

    );
  }
}


