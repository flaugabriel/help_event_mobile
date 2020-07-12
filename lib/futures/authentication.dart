import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  String url = 'http://192.168.100.8:8000';
  final Dio dio = new Dio();

  SharedPreferences sharedPreferences;

  Future<bool> signIn(String name, String password) async {

    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'name': name, 'password': password};

    try {
      var response = await dio.post(url+"/v1/auth/sign_in",data: data,options: Options(headers: {"requiresToken" : true}));
      sharedPreferences.setString("token", response.headers['access-token'][0]);
      sharedPreferences.setString("client", (response.headers['client'][0]));
      sharedPreferences.setString("uid",(response.headers['uid'][0]));
      return true;
    } on DioError catch (e){
      print(e);
    }

  }

  Future<bool> signOut() async {
    sharedPreferences = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      "access-token": "${sharedPreferences.getString("token")}",
      "uid": "${sharedPreferences.getString("uid")}",
      "client": "${sharedPreferences.getString("client")}"
    };
    print(headers);
    try {
      var response = await dio.post("$url/v1/auth/sign_out",options: Options(headers: headers) );
      print(response.data);
      sharedPreferences.getString("token") == null;
      sharedPreferences.getString("client") == null;
      sharedPreferences.getString("uid") == null;
      return true;
    } on DioError catch (e){
      print(e);
      return false;
    }
  }

  Future<bool> isLoged() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getString("token") == null){
      print(sharedPreferences.getString("token") );
      print(sharedPreferences.getString("uid") );
      print(sharedPreferences.getString("client") );
      return true;
    }else{
      return false;
    }
  }
}
