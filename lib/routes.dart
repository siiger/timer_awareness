import 'package:flutter/material.dart';
import 'package:norbu_timer/timer_page.dart';
import 'package:norbu_timer/widgets/notification_details_page.dart';
import 'package:norbu_timer/widgets/notifications_home_page.dart';

//const String PAGE_HOME = '/';
const String PAGE_MEDIA_DETAILS = '/media-details';
const String PAGE_SETTINGS = '/notification-details';
const String PAGE_NOTIFICATION_HOME = '/notification-home';

Map<String, WidgetBuilder> materialRoutes = {
  //PAGE_HOME: (context) => TimerPage(),
  PAGE_NOTIFICATION_HOME: (context) => NotificationHomePage(),
  PAGE_SETTINGS: (context) => TimerPage(),
};
