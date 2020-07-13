import 'package:flutter/material.dart';
import 'package:help_event_mobile/futures/api/event_api.dart';
import 'package:help_event_mobile/futures/authentication.dart';
import 'package:help_event_mobile/main.dart';
import 'package:help_event_mobile/model/event_model.dart';
import 'package:help_event_mobile/screens/events/show_event.screen.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences sharedPreferences;
  Api api = Api();

  var jsonData;
  EventApi eventApi = EventApi();
  EventModel eventModel = new EventModel();

  @override
  void initState() {
    isLoged();
  }

  @override
  Widget build(BuildContext context) {
   consult();
    print(eventModel.msg);
    return PageView(children: <Widget>[
      Scaffold(
        body: eventModel.event == null
            ? Center(
                child: eventModel.msg == null ?  Text("Sem eventos...", style: TextStyle(fontSize: 24),) :
                CircularProgressIndicator(
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                ),
              )
            : new ListView.separated(
                itemCount: eventModel.event == null ? 0 : eventModel.event.length,
                separatorBuilder: (context, int index)
            => Divider(),
                itemBuilder: (context, int index) {
                  return new Dismissible(
                      key: new Key(eventModel.event[index].description),
                      onDismissed: (direction) {
                        eventModel.event.removeAt(index);
                        Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text("Item removido...")));
                      },
                      background: new Container(color: Colors.red),
                      child: new ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShowEventScreen(
                                  user: (eventModel.event[index].user),
                                  description:
                                      (eventModel.event[index].description),
                                  total: (eventModel.event[index].total),
                                  created_at:
                                      (eventModel.event[index].created_at),
                                  id: (eventModel.event[index].id))));
                        },
                        title: new Text(eventModel.event[index].description),
                        subtitle: new Text("Quantidade de itens "+eventModel.event[index].items.toString()),
                        isThreeLine: true,
                        trailing: Text("R\$ "+eventModel.event[index].total,style: TextStyle(color: Colors.lightGreen, fontSize: 24.0),),
                      ));
                }),
      ),
    ]);
  }

  isLoged() async{
    var isLoged = await api.isLoged();
    if (isLoged) {
      MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen());
    }
  }

  consult() async {
    await  eventApi.consulta();
  }
}
