import 'package:flutter/material.dart';
import 'package:timer_awareness/timer_page.dart';
import 'package:timer_awareness/widgets/notification_details_page.dart';

//const String PAGE_HOME = '/';
const String PAGE_MEDIA_DETAILS = '/media-details';
const String PAGE_NOTIFICATION_DETAILS = '/notification-details';

Map<String, WidgetBuilder> materialRoutes = {
  //PAGE_HOME: (context) => TimerPage(),
  PAGE_NOTIFICATION_DETAILS: (context) =>
      NotificationDetailsPage(ModalRoute.of(context).settings.arguments),
};
