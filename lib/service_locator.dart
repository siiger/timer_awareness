import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:norbu_timer/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:norbu_timer/core/sharedpref_util.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:norbu_timer/core/date_time_util.dart';
import 'package:norbu_timer/model/data_timer.dart';

const channelAwarenessDelayedTask = "channelAwarenessDelayedTask";
const tagAwaTask = "AwaTask";
const channelAwareness = 'awareness';
const int idAwa = 1;

final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  //

  SharedPreferences preferences = await SharedPreferences.getInstance();

  final SharedPrefUtil sharedPrefTimer =
      SharedPrefUtil(preferences: preferences);
  sl.registerSingleton<SharedPrefUtil>(sharedPrefTimer);

  //
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  sl.registerSingleton<GlobalKey>(navigatorKey);

  //

  final notificationService = NotificationService(
      awesomeLocalNotifications: awesomeNotifications,
      navigatorKey: navigatorKey);
  await notificationService.init();
  sl.registerSingleton<NotificationService>(notificationService);

  //
  final AudioPlayer audioPlayer = AudioPlayer();
  sl.registerSingleton<AudioPlayer>(audioPlayer);
}
