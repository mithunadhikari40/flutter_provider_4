import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/core/base_widget.dart';
import 'package:flutter_provider_arch/core/constants/app_contstants.dart';
import 'package:flutter_provider_arch/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewViewModel>(
      model: HomeViewViewModel(homeViewService: Provider.of(context)),
      onModelReady: _onModelReady,
      builder: (BuildContext context, HomeViewViewModel model, Widget child) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Awesome places"),
              centerTitle: true,
              actions: <Widget>[
                _buildSyncIcon(context),
                _buildThemeIcon(context),
              ],
            ),
            floatingActionButton: _buildFloatingActionButton(context, model),
            body: Center(child: Text('Home View')));
      },
    );
  }

  Widget _buildSyncIcon(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.sync),
      onPressed: () {},
    );
  }

  Widget _buildThemeIcon(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.theaters),
      onPressed: () {},
    );
  }

  _onModelReady(HomeViewViewModel model) {
    model.getAllPlaces();
    //initial data fetching
  }

  Widget _buildFloatingActionButton(
      BuildContext context, HomeViewViewModel model) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(RoutePaths.AddNewPlace);
      },
    );
  }
}
