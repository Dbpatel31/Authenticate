
import 'package:get/get.dart';

import '../views/auth/sign_in_view.dart';
import '../views/auth/sign_up_view.dart';
import '../views/home/home_view.dart';
import 'auth_guard.dart';

abstract class Routes{
  static const signup= _Paths.signup;
  static const login = _Paths.login;
  static const home = _Paths.home;
}

abstract class _Paths{
  static const signup= '/signup';
  static const login= '/login';
  static const home= '/home';
}

class AppPages{
  static const initial = Routes.signup;

  static final pages= <GetPage>[
    GetPage(
        name: Routes.signup,
        page: ()=>  SignUpView(),

    ),
    GetPage(
        name: Routes.login,
        page: ()=>  LoginPage(),

    ),
    GetPage(
        name: Routes.home,
        page: ()=>  HomePage(),
        // middlewares: [
        //   AuthGuard()
        // ],

    )
  ];
}