import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:help_event_mobile/futures/authentication.dart';
import 'package:help_event_mobile/model/event_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventItemApi {
  Api authenticate = Api();
  String url = 'http://192.168.100.8:8000';
  final Dio dio = new Dio();

  var jsonData;
  EventItemModel eventItemModel;

  SharedPreferences sharedPreferences;

  Future<EventItemModel> getItems(int  id) async {
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
      var response = await dio.get("$url/api/v1/events/${id}",
          options: Options(headers: {"requiresToken": true}));
      sharedPreferences.setString("token", (response.headers['access-token'][0].toString()));
      sharedPreferences.setString("client", (response.headers['client'][0].toString()));
      sharedPreferences.setString("uid",(response.headers['uid'][0]).toString());
      jsonData = json.decode(response.data);
      eventItemModel = EventItemModel.fromJson(jsonData);
    }on DioError catch (e){
      print(e);
    }
  }
}