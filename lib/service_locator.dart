import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:timer_awareness/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:timer_awareness/core/sharedpref_util.dart';

GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  //

  SharedPreferences preferences = await SharedPreferences.getInstance();

  final SharedPrefUtil sharedPrefTimer =
      SharedPrefUtil(preferences: preferences);
  sl.registerSingleton<SharedPrefUtil>(sharedPrefTimer);

  //
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  sl.registerSingleton<GlobalKey>(navigatorKey);

  //
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  final notificationService = NotificationService(
      awesomeLocalNotifications: awesomeNotifications,
      navigatorKey: navigatorKey);
  await notificationService.init();
  sl.registerSingleton<NotificationService>(notificationService);

  //
  final AudioPlayer audioPlayer = AudioPlayer();
  sl.registerSingleton<AudioPlayer>(audioPlayer);
}
