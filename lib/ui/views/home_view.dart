import 'package:flutter/material.dart';
import 'package:flutter_provider_arch/core/base_widget.dart';
import 'package:flutter_provider_arch/core/constants/app_contstants.dart';
import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/ui/widgets/home_item_tile.dart';
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
                _buildSyncIcon(context, model),
                _buildThemeIcon(context),
              ],
            ),
            floatingActionButton: _buildFloatingActionButton(context, model),
            body: _buildBody(model, context));
      },
    );
  }

  Widget _buildSyncIcon(BuildContext context, HomeViewViewModel model) {
    if (!model.isConnected) {
      return IconButton(
        icon: Icon(Icons.sync_disabled),
        onPressed: null,
      );
    }
    return IconButton(
      icon: Icon(Icons.sync),
      onPressed: () {
        model.postData();
      },
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
        Navigator.of(context)
            .pushNamed(RoutePaths.AddNewPlace, arguments: model);
      },
    );
  }

  Widget _buildBody(HomeViewViewModel model, BuildContext context) {
    if (model.busy) {
      return Center(child: CircularProgressIndicator());
    }
    if (model.places.length == 0) {
      return Center(child: Text("No items"));
    }
    return ListView.builder(
      itemCount: model.places.length,
      itemBuilder: (BuildContext context, int index) {
        return HomeItemTile(model.places[index], onPlaceSelected);
      },
    );
  }

 void onPlaceSelected(Place place, BuildContext context) {

    Navigator.of(context).pushNamed(RoutePaths.PlaceDetail,arguments:place);
  }
}
