import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CancelToken{
  bool _cancelled= false;
  void cancle()=> _cancelled = true;
  bool get cancelled=> _cancelled;
}

class AuthService extends GetxService{
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final Rxn<User>currentUser= Rxn<User>();
  late StreamSubscription<User?>_authSub;

  Future<AuthService>init() async{
    _authSub= _auth.authStateChanges().listen((user){
      currentUser.value= user;
    });
    return this;
  }
  Stream<User?> get userStream => _auth.authStateChanges();
  @override
  void onClose() {
    _authSub.cancel();
    super.onClose();
  }

  Future<void>_checkConnectivity() async{
    final conn= await Connectivity().checkConnectivity();
    if(conn==ConnectivityResult.none){
      throw Exception("No internet connection");
    }
  }

  Future<UserCredential>signIn({
    required String email,
    required String password,
    CancelToken?cancelToken,
    int maxRetries=3,
    void Function(double progress)? onProgrss,
  }) async{
    await _checkConnectivity();

    int attempts=0;

    Duration backoff(int n)=> Duration(milliseconds: 200*(1<<(n-1)));

    while(true){
      if(cancelToken?.cancelled??false) throw Exception("Sign-in cancelled");

      attempts++;
      try{
        onProgrss?.call(0.0);
        final cred= await _auth.signInWithEmailAndPassword(email: email, password: password).timeout(const Duration(seconds: 10));
        onProgrss?.call(1.0);
        return cred;
      } on FirebaseAuthException catch(e){
        if(attempts >= maxRetries){
          rethrow;
        }
        final wait= backoff(attempts);
        print("Sign-in attempt $attempts failed -> retry in ${wait.inMilliseconds}ms: ${e.code}");
        await Future.delayed(wait);
      }
    }
  }

  Future<UserCredential>signUp({
    required String email,
    required String password,
    CancelToken? cancelToken,
    void Function(double progress)? onProgress,
    int maxRetries=3
  }) async{
    await _checkConnectivity();

    int attempts=0;

    Duration backoff(int n)=> Duration(milliseconds: 200*(1<<(n-1)));

    while (true) {
      if (cancelToken?.cancelled ?? false) throw Exception("Sign-up cancelled");
      attempts++;
      try {
        onProgress?.call(0.0);
        final cred = await _auth .createUserWithEmailAndPassword(email: email, password: password) .timeout(const Duration(seconds: 10));
        onProgress?.call(1.0);
        return cred;
      } on FirebaseAuthException catch (e) {
        if (attempts >= maxRetries)  rethrow;
        final wait = backoff(attempts);
        print('⚡ Sign-up attempt $attempts failed → retry in ${wait.inMilliseconds}ms: ${e.code}');
        await Future.delayed(wait);
      }

    }


  }

  Future<void> signOut() async { await _auth.signOut(); }
}