import 'package:authenticate/services/auth_service.dart';
import 'package:authenticate/services/local_storage_service.dart';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';

class AppBindings extends Bindings{

  static Future<void>initServices() async{
    await Get.putAsync(()=>LocalStorageService().init());
    await Get.putAsync(() => AuthService().init());

    Get.lazyPut(()=> AuthController(), fenix: true);

  }
  @override
  void dependencies() {

  }

}