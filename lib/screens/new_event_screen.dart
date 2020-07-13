import 'package:flutter/material.dart';
import 'package:help_event_mobile/futures/authentication.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:help_event_mobile/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewEventScreen extends StatefulWidget {
  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {

  Api authentication = Api();

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _data_eventController = TextEditingController();

  bool _isLoading = false;

  DateTime _date = new DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 1095)),
    );


    if (picked != null && picked != DateTime.now()) {
      print("Data selecionada ${_date}");
      setState(() {
        _date = picked;
        _data_eventController.text = "${picked}";
      });
    }
  }

  isLoged() async {
    var isLoged = await authentication.isLoged();
    if (isLoged) {
      MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences sharedPreferences;

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Color.fromRGBO(251, 173, 59, 1),
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: new IconThemeData(color: Colors.white, size: 100.0),
            elevation: 0.0,
          ),
          drawer: CustomDrawer(),
          body: Scaffold(
            backgroundColor: Color.fromRGBO(251, 173, 59, 1),
            body: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, top: 0, bottom: 10, right: 20),
                      child: TextFormField(
                        controller: _descriptionController,
                        validator: (text) {
                          if (text.isEmpty) return "Descrição não inserida!";
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Descrição",
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.7),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, top: 16, bottom: 10, right: 20),
                      child: TextFormField(
                        onTap: () {
                          _selectDate(context);
                        },
                        controller: _data_eventController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Data do evento",
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.7),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                        validator: (text) {
                          if (text.isEmpty) return "Valor não inserido!";
                        },
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.only(
                          left: 20, top: 16, bottom: 10, right: 20),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                            BorderRadius.all(Radius.circular(32))),
                        child: Center(
                          child: Text(
                            "Criar",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          isLoged();
//                          createEvent(_descriptionController.text,
//                              _data_eventController.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
