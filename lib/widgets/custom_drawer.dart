import 'package:flutter/material.dart';
import 'package:help_event_mobile/titles/drawer_title.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

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
                          )),

                    ],
                  ),
                ),
                Divider(),
                DrawerTitle(Icons.dashboard, "Dashboard", pageController, 0),
                DrawerTitle(Icons.list, "Meus Itens", pageController, 1),
                DrawerTitle(Icons.notification_important, "Notificações",
                    pageController, 2),
                DrawerTitle(Icons.add, "Novo evento", pageController, 3),
                DrawerTitle(Icons.add, "Novo item", pageController, 4),
                DrawerTitle(Icons.person, "Configurações", pageController, 5),
              ],
            )
          ],
        ),
      ),
    );
  }
}