import 'package:flutter/material.dart';
import 'package:help_event_mobile/futures/api/item_api.dart';
import 'package:help_event_mobile/futures/authentication.dart';
import 'package:help_event_mobile/model/item_model.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:help_event_mobile/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewItemScreen extends StatefulWidget {
  @override
  _NewItemScreenState createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  Api authentication = Api();
  ItemApi itemapi = ItemApi();
  ItemModel itemModel = new ItemModel();

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SharedPreferences sharedPreferences;

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.grey,
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: new IconThemeData(color: Colors.white, size: 100.0),
            elevation: 0.0,
          ),
          drawer: CustomDrawer(),
          body: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 50,
                    left: 50,
                    top: 50,
                    child: Container(
                      child: Text("Novo item", style: TextStyle(fontSize: 24,color: Colors.black),)
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20, top: 10, bottom: 10, right: 20),
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
                            controller: _valueController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintText: "Preço",
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
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20, top: 16, bottom: 10, right: 20),
                          child: TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintText: "Local",
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
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              isLoged();
                            var res =  await itemapi.create(_descriptionController.text,
                                  _valueController.text, _locationController.text);
                            notification(res);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ],
    );
  }

  isLoged() async {
    var isLoged = await authentication.isLoged();
    if (isLoged) {
      MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen());
    }
  }

  notification(res) {
    print(res);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: (res == null) ? Text("Salvo!") :Text("Erro interno") ,
          );
        });
  }
}