
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';

class AuthController extends GetxController{

  final AuthService _authService= Get.find<AuthService>();
  final LocalStorageService _localStorage= Get.find<LocalStorageService>();



  Rxn<User>firebaseUser= Rxn<User>();

  var isLoading= false.obs;


  @override
  void onInit() {

    super.onInit();
    _initAuth();

  }

  Future<void> _initAuth() async {

     firebaseUser.bindStream(_authService.userStream);



      ever<User?>(firebaseUser, _handleAuthChanged);
      _checkAutoLogin();

  }
  void _handleAuthChanged(User? user) {

    if (user != null) {

      if (Get.currentRoute != Routes.home) {
        Get.toNamed(Routes.home);
      }
    } else {

      if (Get.currentRoute != Routes.login) {
        Get.toNamed(Routes.login);
      }
    }
  }

  Future<void>_checkAutoLogin() async{
    final savedEmail = _localStorage.getEmail();
    final savedPassword = _localStorage.getPassword();

    if(savedEmail != null && savedPassword!=null){
      try{
        isLoading.value = true;
        await _authService.signIn(
            email: savedEmail,
            password: savedPassword
        );
        print("Auto login success with $savedEmail");
      }
      catch (e){
        print(" Auto login failed: $e");
      }
      finally{
        isLoading.value = false;
      }
    }
  }

  Future<void>signIn(String email, String password, {bool rememberMe = false}) async{
    try{
      isLoading.value = true;
      await _authService.signIn(email: email, password: password);

      if (rememberMe) {
        await _localStorage.saveCredentials(email, password);
      }
      Get.toNamed(Routes.home);
    }
    catch (e){
      Get.snackbar("Login Failed", e.toString());
    }
    finally{
      isLoading.value= false;
    }
  }

  Future<void> signUp(String email, String password,
      {bool rememberMe = false}) async {
    try {
      isLoading.value = true;
      await _authService.signUp(email: email, password: password);

      if (rememberMe) {
        await _localStorage.saveCredentials(email, password);

      }

    } catch (e) {
      Get.snackbar("Signup Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
      await _localStorage.clear();
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  bool get isLoggedIn => firebaseUser.value != null;
}