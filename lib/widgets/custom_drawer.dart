import 'package:flutter/material.dart';
import 'package:help_event_mobile/screens/login_screen.dart';

class CustomDrawer extends StatelessWidget {

  Widget _buidDrawerBack() => Container(
        color: Color.fromRGBO(67, 64, 60, 1),
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
      child: Drawer(
        child: Stack(
          children: <Widget>[
            _buidDrawerBack(),
            ListView(
              padding: EdgeInsets.only(left: 32.0),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                  height: 170,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 18.0,
                        left: 18.0,
                        child: Image.asset(
                          "images/logo.png",
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 60.0,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.dashboard,
                            size: 32.0,
                            color: Colors.white,
                            // controller.page.round() == page ?
                            // Colors.white : Colors.grey[700] ,
                          ),
                          SizedBox(width: 32.0),
                          Text(
                            "Dashboard",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 60.0,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.list,
                            size: 32.0,
                            color: Colors.white,
                            // controller.page.round() == page ?
                            // Colors.white : Colors.grey[700] ,
                          ),
                          SizedBox(width: 32.0),
                          Text(
                            "Meus Itens",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 60.0,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.notification_important,
                            size: 32.0,
                            color: Colors.white,
                            // controller.page.round() == page ?
                            // Colors.white : Colors.grey[700] ,
                          ),
                          SizedBox(width: 32.0),
                          Text(
                            "Notificações",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 60.0,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            size: 32.0,
                            color: Colors.white,
                            // controller.page.round() == page ?
                            // Colors.white : Colors.grey[700] ,
                          ),
                          SizedBox(width: 32.0),
                          Text(
                            "Novo evento",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 60.0,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            size: 32.0,
                            color: Colors.white,
                            // controller.page.round() == page ?
                            // Colors.white : Colors.grey[700] ,
                          ),
                          SizedBox(width: 32.0),
                          Text(
                            "Novo Item",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 60.0,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            size: 32.0,
                            color: Colors.white,
                            // controller.page.round() == page ?
                            // Colors.white : Colors.grey[700] ,
                          ),
                          SizedBox(width: 32.0),
                          Text(
                            "Configurações",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(),
                  Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 60.0,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.power_settings_new,
                            size: 32.0,
                            color: Colors.red,
                            // controller.page.round() == page ?
                            // Colors.white : Colors.grey[700] ,
                          ),
                          SizedBox(width: 32.0),
                          Text(
                            "Sair",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.red),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  signOut(){

  }
}
