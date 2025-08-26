
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/local_storage_service.dart';
import 'app_pages.dart';

class AuthGuard extends GetMiddleware{
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  @override
  RouteSettings? redirect(String? route) {
    final email= _storage.getEmail();
    final password= _storage.getPassword();

    if(email!=null && password!=null){
      return  RouteSettings(name: Routes.home);
    }
    else{
      return  RouteSettings(name: Routes.login);
    }


  }
}