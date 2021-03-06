import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_event_mobile/futures/authentication.dart';
import 'package:help_event_mobile/main.dart';
import 'package:help_event_mobile/screens/home_screen.dart';
import 'package:help_event_mobile/screens/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Api api = Api();

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    height: 350,
                    child: Image.asset(
                      "images/icone.png",
                    ),
                  ),
                  Positioned(
                    top: 210,
                    left: 32,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    top: 250,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 32, horizontal: 40),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(62),
                              topRight: Radius.circular(62))),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              validator: (text) {
                                if (text.isEmpty || !text.contains("@"))
                                  return "E-mail inválido!";
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "E-mail",
                                  icon: Icon(Icons.person)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 62),
                              child: TextFormField(
                                controller: _passController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Senha",
                                  icon: Icon(Icons.vpn_key),
                                ),
                                obscureText: true,
                                validator: (text) {
                                  if (text.isEmpty || text.length < 6)
                                    return "Senha inválida!";
                                },
                              ),
                            ),
                            FlatButton(
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                child: Center(
                                  child: Text(
                                    "ENTRAR",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  var res = await api.signIn(_emailController.text,
                                      _passController.text);
                                  if (res) {
                                      _isLoading = true;
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MainPage()),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    _isLoading = false;
                                    opendialog();
                                  };
                                }
                              },
                            ),
                            Container(
                              height: 8,
                            ),
                            FlatButton(
                              onPressed: () {},
                              child: Text(
                                "Esqueci minha senha?",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 15.0),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()));
                              },
                              child: Text(
                                "Criar conta?",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  opendialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("E-mail ou Senha incorretos"),
            actions: <Widget>[
              FlatButton(
                child: Text("ok"),
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                },
              ),
            ],
          );
        });
  }
}
