import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:help_event_mobile/futures/authentication.dart';
import 'package:help_event_mobile/model/event_model.dart';
import 'package:help_event_mobile/model/item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemApi {
  Api authenticate = Api();
  String url = 'http://192.168.100.8:8000';
  final Dio dio = new Dio();

  var jsonData;
  ItemModel itemModel;

  SharedPreferences sharedPreferences;

  Future<EventModel> create(
      String description, String value, String location) async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("tokenvalidadecreate");
    print(sharedPreferences.getString("token"));
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var customHelpers = {
        'content-type': 'application/json',
        "access-token": "${sharedPreferences.getString("token")}",
        "uid": "${sharedPreferences.getString("uid")}",
        "client": "${sharedPreferences.getString("client")}"
      };
      options.headers.addAll(customHelpers);
      return options;
    }));

    Map data = {
      "description": "${description}",
      "value": "${double.parse(value)}",
      "location": "${location}"
    };

    try {
      var response = await dio.post("$url/api/v1/items",
          data: data, options: Options(headers: {"requiresToken": true}));
      sharedPreferences.setString("token", (response.headers['access-token'][0]));
      sharedPreferences.setString("client", (response.headers['client'][0]));
      sharedPreferences.setString("uid",(response.headers['uid'][0]));
      jsonData = json.decode(response.data);
      itemModel = ItemModel.fromJson(jsonData);
    } on DioError catch (e) {
      print(e);
    }
  }
}
