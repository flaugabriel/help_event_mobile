import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_event_mobile/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _pass_confirmationController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    "Criar conta",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  top: 250,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 32, horizontal: 40),
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
                            controller: _nameController,
                            validator: (text) {
                              if (text.isEmpty) return "Apelido inválido!";
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Apelido",
                                icon: Icon(Icons.person_pin)),
                          ),
                          Divider(),
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
                            padding: EdgeInsets.only(top: 16, bottom: 18),
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
                          Padding(
                            padding: EdgeInsets.only(top: 0, bottom: 32),
                            child: TextFormField(
                              controller: _pass_confirmationController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Confirme sua senha",
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
                                  "Criar conta",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                              }
                            },
                          ),
                          Container(
                            height: 8,
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
}