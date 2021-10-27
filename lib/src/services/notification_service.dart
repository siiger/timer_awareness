import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:norbu_timer/src/config/routes.dart';
import 'package:norbu_timer/src/features/timer/util/timer_strings_util.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:norbu_timer/src/core/utils/date_time_util.dart';
import 'package:norbu_timer/service_locator.dart';
import 'package:norbu_timer/src/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;
  if (timeout) {
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }

  var prefs = await SharedPreferences.getInstance();
  final LocalStorageService dataTimerTask = LocalStorageService(preferences: prefs);

  DateTime currentTime = DateTime.now();

  DateTime nexTime = DateTimeUtil.nextTime(
      currentTime: currentTime,
      intervalValue: dataTimerTask.intervalPre,
      timeFrom: dataTimerTask.timeFrom,
      timeUntil: dataTimerTask.timeUntil,
      intervalSource: dataTimerTask.intervalSourcePre,
      isTimeOnActivated: dataTimerTask.isTimeOffPre);

  int intervalDelay = nexTime.difference(currentTime).inMinutes;

  if (intervalDelay > dataTimerTask.intervalPre) {
    BackgroundFetch.finish(taskId);
    return;
  } else if (intervalDelay <= dataTimerTask.intervalPre) {
    List<String> messageListResault = [];
    for (int i = 0; i < dataTimerTask.listMessagesPre.length; i++) {
      if (dataTimerTask.listCheckMessagesPre.contains(i.toString()))
        messageListResault..add(dataTimerTask.listMessagesPre[i]);
    }

    String messageResault = ' ';
    for (int i = 0; i < TimerStringsUtil.lengthTaskList; i++) {
      if (messageListResault.isNotEmpty) {
        if (messageListResault.length > 1) {
          var index = Random().nextInt(messageListResault.length);
          messageResault = messageListResault[index];
        } else if (messageListResault.length == 1) {
          messageResault = messageListResault[0];
        }
      }
    }
    if (dataTimerTask.soundSourcePre < 3) {
      String _soundSourcePath = TimerStringsUtil.soundSourceArray[dataTimerTask.soundSourcePre];

      await awesomeNotifications.setChannel(NotificationChannel(
        channelKey: channelAwareness,
        channelName: 'Norbu_Timer',
        channelDescription: 'Timer settinings',
        channelShowBadge: false,
        playSound: true,
        soundSource: _soundSourcePath,
        enableVibration: false,
        importance: NotificationImportance.High,
      ));
    } else if (dataTimerTask.soundSourcePre == 3) {
      await awesomeNotifications.setChannel(NotificationChannel(
          channelKey: channelAwareness,
          channelName: 'Norbu_Timer',
          channelDescription: 'Timer settinings',
          channelShowBadge: false,
          enableVibration: false,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          importance: NotificationImportance.High));
    }

    await awesomeNotifications.createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: channelAwareness,
            title: messageResault,
            body: 'Таймер осознанности',
            payload: {'uuid': 'user-profile-uuid1'}),
        actionButtons: [
          NotificationActionButton(
            key: 'Settings_Timer',
            label: 'Настройки таймера осознанности',
            autoCancel: true,
            buttonType: ActionButtonType.Default,
          )
        ],
        schedule: NotificationCalendar.fromDate(date: nexTime.toUtc()));

    BackgroundFetch.finish(taskId);
  }
}

void _onBackgroundFetch(String taskId) async {
  var prefs = await SharedPreferences.getInstance();
  final LocalStorageService dataTimerTask = LocalStorageService(preferences: prefs);

  DateTime currentTime = DateTime.now();

  DateTime nexTime = DateTimeUtil.nextTime(
      currentTime: currentTime,
      intervalValue: dataTimerTask.intervalPre,
      timeFrom: dataTimerTask.timeFrom,
      timeUntil: dataTimerTask.timeUntil,
      intervalSource: dataTimerTask.intervalSourcePre,
      isTimeOnActivated: dataTimerTask.isTimeOffPre);

  int intervalDelay = nexTime.difference(currentTime).inMinutes;

  if (intervalDelay > dataTimerTask.intervalPre) {
    BackgroundFetch.finish(taskId);
    return;
  } else if (intervalDelay <= dataTimerTask.intervalPre) {
    List<String> messageListResault = [];
    for (int i = 0; i < dataTimerTask.listMessagesPre.length; i++) {
      if (dataTimerTask.listCheckMessagesPre.contains(i.toString()))
        messageListResault..add(dataTimerTask.listMessagesPre[i]);
    }

    String messageResault = ' ';
    for (int i = 0; i < TimerStringsUtil.lengthTaskList; i++) {
      if (messageListResault.isNotEmpty) {
        if (messageListResault.length > 1) {
          var index = Random().nextInt(messageListResault.length);
          messageResault = messageListResault[index];
        } else if (messageListResault.length == 1) {
          messageResault = messageListResault[0];
        }
      }
    }
    if (dataTimerTask.soundSourcePre < 3) {
      String _soundSourcePath = TimerStringsUtil.soundSourceArray[dataTimerTask.soundSourcePre];

      await awesomeNotifications.setChannel(NotificationChannel(
        channelKey: channelAwareness,
        channelName: 'Norbu_Timer',
        channelDescription: 'Timer settinings',
        channelShowBadge: false,
        playSound: true,
        soundSource: _soundSourcePath,
        enableVibration: false,
        importance: NotificationImportance.High,
      ));
    } else if (dataTimerTask.soundSourcePre == 3) {
      await awesomeNotifications.setChannel(NotificationChannel(
          channelKey: channelAwareness,
          channelName: 'Norbu_Timer',
          channelDescription: 'Timer settinings',
          channelShowBadge: false,
          enableVibration: false,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          importance: NotificationImportance.High));
    }

    await awesomeNotifications.createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: channelAwareness,
            title: messageResault,
            body: 'Таймер осознанности',
            payload: {'uuid': 'user-profile-uuid1'}),
        actionButtons: [
          NotificationActionButton(
            key: 'Settings_Timer',
            label: 'Настройки таймера осознанности',
            autoCancel: true,
            buttonType: ActionButtonType.Default,
          )
        ],
        schedule: NotificationCalendar.fromDate(date: nexTime.toUtc()));

    BackgroundFetch.finish(taskId);
  }
}

/// This event fires shortly before your task is about to timeout.  You must finish any outstanding work and call BackgroundFetch.finish(taskId).
void _onBackgroundFetchTimeout(String taskId) {
  print("[BackgroundFetch] TIMEOUT: $taskId");
  BackgroundFetch.finish(taskId);
}

class NotificationService {
  final AwesomeNotifications _awesomeLocalNotifications;
  final GlobalKey<NavigatorState> _navigatorKey;

  NotificationService(
      {@required AwesomeNotifications awesomeLocalNotifications, @required GlobalKey<NavigatorState> navigatorKey})
      : assert(awesomeLocalNotifications != null, navigatorKey != null),
        _awesomeLocalNotifications = awesomeLocalNotifications,
        _navigatorKey = navigatorKey;

  StreamSubscription<ReceivedAction> _actionStream;

  List<String> _notificationMessages = [];
  String _soundSourcePath = TimerStringsUtil.soundSourceArray[0];

  Future init() async {
    await _awesomeLocalNotifications.initialize('resource://drawable/res_norbu_notific', []);

    await _awesomeLocalNotifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        _awesomeLocalNotifications.requestPermissionToSendNotifications();
      }
    });

    _actionStream = _awesomeLocalNotifications.actionStream.listen((receivedNotification) {
      if (!StringUtils.isNullOrEmpty(receivedNotification.buttonKeyPressed) &&
          receivedNotification.buttonKeyPressed.startsWith('Settings_')) {
        processSettingsControls(receivedNotification);
      } else {
        processDefaultActionReceived(receivedNotification);
      }
    });
  }

  void dispose() {
    _actionStream.cancel();
  }

  //if tap notifications
  void processDefaultActionReceived(ReceivedAction receivedNotification) {
    //Fluttertoast.showToast(msg: 'Action received');
    String targetPage;
    targetPage = PAGE_NOTIFICATION_HOME;
    // Avoid to open the notification details page over another details page already opened
    _navigatorKey.currentState.pushNamedAndRemoveUntil(
        targetPage, (route) => (route.settings.name != targetPage) || route.isFirst,
        arguments: receivedNotification);
  }

  //if press button
  void processSettingsControls(ReceivedAction receivedNotification) {
    String targetPage;
    targetPage = PAGE_SETTINGS;

    _navigatorKey.currentState
        .pushNamedAndRemoveUntil(targetPage, (route) => (route.settings.name != targetPage) || route.isFirst);
  }

  Future<void> setupChannelAwarness({
    int soundSource,
  }) async {
    if (soundSource < 3) {
      _soundSourcePath = TimerStringsUtil.soundSourceArray[soundSource];

      await _awesomeLocalNotifications.setChannel(NotificationChannel(
        channelKey: channelAwareness,
        channelName: 'Norbu_Timer',
        channelDescription: 'Timer settinings',
        channelShowBadge: false,
        playSound: true,
        soundSource: _soundSourcePath,
        enableVibration: false,
        importance: NotificationImportance.High,
      ));
    } else if (soundSource == 3) {
      await _awesomeLocalNotifications.setChannel(NotificationChannel(
          channelKey: channelAwareness,
          channelName: 'Norbu_Timer',
          channelDescription: 'Timer settinings',
          channelShowBadge: false,
          enableVibration: false,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          importance: NotificationImportance.High));
    }
  }

  Future<void> setupNotificationsTaskForChannelAwareness({
    int intervalValue,
  }) async {
    await cancelNotificationsTaskForChannelAwareness();

    try {
      var status = await BackgroundFetch.configure(
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
      print('[BackgroundFetch] configure success: $status');
    } catch (e) {
      print("[BackgroundFetch] configure ERROR: $e");
    }

    BackgroundFetch.start().then((int status) {
      print('[BackgroundFetch] start success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] start FAILURE: $e');
    });

    //_log.fine('Schedule notification at $notificationDateTime');
  }

  void setupNotificationMessages({List<String> messages}) {
    _notificationMessages.clear();
    _notificationMessages.addAll(messages);
  }

  Future<void> removeChannel(String channelKey) async {
    _awesomeLocalNotifications.removeChannel(channelKey);
  }

  Future<void> cancelSchedule(int id) async {
    await _awesomeLocalNotifications.cancelSchedule(id);
  }

  Future<void> cancelAllSchedules() async {
    await _awesomeLocalNotifications.cancelAllSchedules();
  }

  Future<void> cancelNotification(int id) async {
    await _awesomeLocalNotifications.cancel(id);
  }

  Future<void> cancelNotificationsTaskForChannelAwareness() async {
    await cancelSchedule(0);
    await cancelNotification(0);
    BackgroundFetch.stop().then((int status) {
      print('[BackgroundFetch] stop success: $status');
    });
  }
}
