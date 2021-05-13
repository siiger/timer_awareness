import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter/material.dart' as Material show DateUtils;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:progressive_image/progressive_image.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:norbu_timer/routes.dart';

class NotificationHomePage extends StatefulWidget {
  //String get results => receivedNotification.toString();
  //final ReceivedNotification receivedNotification;

  final String title = 'Notification Home';

  NotificationHomePage();

  @override
  _NotificationHomePageState createState() => _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {
  String displayedDate = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 40.0),
        children: <Widget>[
          SizedBox(height: 30),
          Center(child: Text('HOME')),
          SizedBox(height: 30),
          RaisedButton(
              child: Text(
                'Timer Settings',
                //state.isRealTimeMode ? "Stop" : "Run",
                style: TextStyle(fontSize: 16),
              ),
              color: Colors.blueGrey,
              textColor: Colors.black,
              onPressed: () => Navigator.pushNamed(context, PAGE_SETTINGS)),
        ],
      ),
    );
  }
}
