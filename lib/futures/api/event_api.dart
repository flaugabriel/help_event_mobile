import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:help_event_mobile/futures/authentication.dart';
import 'package:help_event_mobile/model/event_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventApi {
  Api authenticate = Api();
  String url = 'http://192.168.100.8:8000';
  final Dio dio = new Dio();

  var jsonData;
  EventModel eventModel;

  SharedPreferences sharedPreferences;

  Future<EventModel> consulta() async {
    sharedPreferences = await SharedPreferences.getInstance();

    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) async{
      var customHelpers = {
        'content-type': 'application/json',
        "access-token": "${sharedPreferences.getString("token")}",
        "uid": "${sharedPreferences.getString("uid")}",
        "client": "${sharedPreferences.getString("client")}"
      };
      options.headers.addAll(customHelpers);
      return options;
    }));
    try{
      var response = await dio.get("$url/api/v1/",
          options: Options(headers: {"requiresToken": true}));
      sharedPreferences.setString("token", (response.headers['access-token'][0]));
      sharedPreferences.setString("client", (response.headers['client'][0]));
      sharedPreferences.setString("uid",(response.headers['uid'][0]));
       if(response.data['event'].length == 0) {
         response.data = null;
         eventModel = EventModel.fromJson(response.data);
       }else{
         jsonData = json.decode(response.data);
         eventModel = EventModel.fromJson(jsonData);
       }
    }on DioError catch (e){
    }
  }

}