import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_awareness/bloc_notification/notification_bloc.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timer_awareness/timer_page.dart';
import 'package:timer_awareness/routes.dart';

void main() async {
  AwesomeNotifications().initialize('resource://drawable/res_app_icon', []);

  runApp(App());
}

class App extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  static Color mainColor = Color(0xFF9D50DD);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      routes: materialRoutes,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(109, 234, 255, 1),
        accentColor: Color.fromRGBO(72, 74, 126, 1),
        brightness: Brightness.dark,
      ),
      title: 'Timer Awareness',
      home: BlocProvider(
        create: (context) => NotificationService(navigatorKey: _navigatorKey),
        child: TimerPage(),
      ),
    );
  }
}
