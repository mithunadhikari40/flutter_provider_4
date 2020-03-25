import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Awesome places"),
          centerTitle: true,
          actions: <Widget>[
            _buildSyncIcon(context),
            _buildThemeIcon(context),
          ],
        ),
        body: Center(child: Text('Home View')));
  }

  Widget _buildSyncIcon(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.sync),
      onPressed: () {},
    );
  }

Widget  _buildThemeIcon(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.theaters),
    onPressed: (){},
  );
}
}
