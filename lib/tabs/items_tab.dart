import 'package:flutter/material.dart';

class ItemsTab extends StatelessWidget {
  Widget _buidBodyBack() => Container(
    color: Color.fromRGBO(251, 173, 59, 1),
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buidBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                 title: const Text(
                   "Meu Inventario",
                   style: TextStyle(color: Colors.white, fontSize: 24),
                 ),
                centerTitle: true,
              ),
            )
          ],
        )
      ],
    );
  }
}