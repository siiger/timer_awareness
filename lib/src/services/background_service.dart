import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:norbu_timer/src/services/managers/awe_noti_manager.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:logging/logging.dart';

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;
  if (timeout) {
    //print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  await notificationUpdateTask();
  BackgroundFetch.finish(taskId);
}

void _onBackgroundFetch(String taskId) async {
  await notificationUpdateTask();
  BackgroundFetch.finish(taskId);
}

/// This event fires shortly before your task is about to timeout.  You must finish any outstanding work and call BackgroundFetch.finish(taskId).
void _onBackgroundFetchTimeout(String taskId) {
  //print("[BackgroundFetch] TIMEOUT: $taskId");
  BackgroundFetch.finish(taskId);
}

Future<bool> notificationUpdateTask() async {
  final NotificationManager manager = await NotificationManager.getInstance();
  manager.updateNotifications();
  return Future.value(true);
}

Future<bool> notificationCancelTask() async {
  final NotificationManager manager = await NotificationManager.getInstance();
  await manager.cancelNotifications();
  return Future.value(true);
}

class BackgroundService {
  Stream<ReceivedAction> notificationActionStream;
  static BackgroundService _instance;

  static Future<BackgroundService> getInstance() async {
    if (_instance == null) {
      _instance = BackgroundService();
      final NotificationManager manager = await NotificationManager.getInstance();
      _instance.notificationActionStream = manager.actionStream;
    }
    return _instance;
  }

  Future<void> setupBackgroundTask({
    int intervalValue,
  }) async {
    await cancelBackgroundTask();

    try {
      await BackgroundFetch.configure(
          BackgroundFetchConfig(
            minimumFetchInterval: intervalValue,
            forceAlarmManager: false,
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE,
          ),
          _onBackgroundFetch,
          _onBackgroundFetchTimeout);
      //print('[BackgroundFetch] configure success: $status');
    } catch (e) {
      //print("[BackgroundFetch] configure ERROR: $e");
    }
  }

  Future<void> cancelBackgroundTask() async {
    await notificationCancelTask();
    await BackgroundFetch.stop().then((int status) {});
  }
}
