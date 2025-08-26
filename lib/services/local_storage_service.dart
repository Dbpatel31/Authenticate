import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends GetxService{
  late SharedPreferences _prefs;

  Future<LocalStorageService>init() async{
    _prefs= await SharedPreferences.getInstance();
    return this;
  }

  Future<void>writeString(String key, String value) async{
    try{
      await _prefs.setString(key, value);
    }
    catch(e){
      print('Faield to write: $e');
    }
  }

  String? readString(String key){
    try{
      return _prefs.getString(key);
    }
    catch(e){
      print("⚠️ Failed to read: $e");
      return null;
    }
  }

  Future<void>clear({void Function(double progress)? onProgress}) async{
    final keys= _prefs.getKeys().toList();
    for(int i=0; i<keys.length; i++){
      await _prefs.remove(keys[i]);
      onProgress?.call((i+1)/keys.length);
      await Future.delayed(Duration.zero);
    }
  }

  Future<void>saveCredentials(String email, String password) async{
    await writeString('email', email);
    await writeString('password', password);
  }

  String? getEmail()=> readString('email');
  String? getPassword()=> readString('password');

}