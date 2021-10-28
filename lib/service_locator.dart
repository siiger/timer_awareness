import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:norbu_timer/src/services/background_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:norbu_timer/src/services/local_storage_service.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:norbu_timer/src/core/utils/date_time_util.dart';
import 'package:norbu_timer/src/features/timer/model/data_timer_model.dart';

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

  final pref = await LocalStorageService.getInstance();
  sl.registerSingleton<LocalStorageService>(pref);

  //
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  sl.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);

  //

  final backgroundService = BackgroundService();
  sl.registerSingleton<BackgroundService>(backgroundService);

  //
  final AudioPlayer audioPlayer = AudioPlayer();
  sl.registerSingleton<AudioPlayer>(audioPlayer);
}
