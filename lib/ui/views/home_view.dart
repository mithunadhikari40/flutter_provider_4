import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_provider_arch/core/base_widget.dart';
import 'package:flutter_provider_arch/core/constants/app_contstants.dart';
import 'package:flutter_provider_arch/core/models/places.dart';
import 'package:flutter_provider_arch/ui/widgets/home_item_tile.dart';
import 'package:flutter_provider_arch/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
   final  FirebaseMessaging  _firebaseMessaging = FirebaseMessaging();

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

  _onModelReady(HomeViewViewModel model) async {




    ///notification initialization --
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);




_firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        
      },
       onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      
     
      print("Firebase token $token");
    });



    model.getAllPlaces();
    //initial data fetching
  }

  Widget _buildFloatingActionButton(
      BuildContext context, HomeViewViewModel model) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          'your channel description',
          importance: Importance.Max,
          priority: Priority.High,
        );
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(0,'Notification title',
            'Notification body', platformChannelSpecifics,
            payload: 'item x');

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
        return HomeItemTile(
            model.places[index], onPlaceSelected, onDelete, onUpdate, model);
      },
    );
  }

  void onPlaceSelected(Place place, BuildContext context) {
    Navigator.of(context).pushNamed(RoutePaths.PlaceDetail, arguments: place);
  }

  void onUpdate(Place place, HomeViewViewModel model) {}
  void onDelete(Place place, HomeViewViewModel model) {}

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {

      }

  Future selectNotification(String payload) async {
    print("selcet notification payload $payload");
  }
}
