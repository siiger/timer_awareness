import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:norbu_timer/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:norbu_timer/core/sharedpref_util.dart';
import 'package:workmanager/workmanager.dart';
import 'package:norbu_timer/core/date_time_util.dart';
import 'package:norbu_timer/model/data_timer.dart';

const channelAwarenessDelayedTask = "channelAwarenessDelayedTask";
const tagAwaTask = "AwaTask";
const channelAwareness = 'awareness';
const int idAwa = 1;

final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

GetIt sl = GetIt.instance;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case channelAwarenessDelayedTask:
        DataTimer dataTimerTask = DataTimer.fromMap(inputData);
        var index = Random().nextInt(dataTimerTask.messages.length);
        await awesomeNotifications.createNotification(
            content: NotificationContent(
                id: idAwa,
                channelKey: channelAwareness,
                title: '${dataTimerTask.messages[index]}',
                body: 'Таймер осознанности',
                payload: {'uuid': 'user-profile-uuid1'}),
            actionButtons: [
              NotificationActionButton(
                key: 'Settings_Timer',
                label: 'Настройки таймера осознанности',
                autoCancel: true,
                buttonType: ActionButtonType.Default,
              )
            ]);
        int intervalDelay = DateTimeUtil.intervalDelayInSeconds(
            intervalValue: dataTimerTask.intervalValue,
            timeFrom: dataTimerTask.timeFrom,
            timeUntil: dataTimerTask.timeUntil,
            intervalSource: dataTimerTask.intervalSource,
            isTimeOnActivated: dataTimerTask.isTimeOnActivated);

        Workmanager().registerOneOffTask(
          tagAwaTask,
          channelAwarenessDelayedTask,
          initialDelay: Duration(seconds: intervalDelay),
          inputData: dataTimerTask.toMap(),
          existingWorkPolicy: ExistingWorkPolicy.append,
        );

        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");

        break;
    }

    return Future.value(true);
  });
}

Future<void> setupLocator() async {
  await Workmanager().initialize(callbackDispatcher);
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
