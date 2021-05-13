import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:norbu_timer/routes.dart';
import 'package:norbu_timer/core/constants.dart';
import 'package:workmanager/workmanager.dart';
import 'package:norbu_timer/core/date_time_util.dart';
import 'package:norbu_timer/model/data_timer.dart';
import 'package:norbu_timer/service_locator.dart';

class NotificationService {
  final AwesomeNotifications _awesomeLocalNotifications;
  final GlobalKey<NavigatorState> _navigatorKey;

  NotificationService(
      {@required AwesomeNotifications awesomeLocalNotifications,
      @required GlobalKey<NavigatorState> navigatorKey})
      : assert(awesomeLocalNotifications != null, navigatorKey != null),
        _awesomeLocalNotifications = awesomeLocalNotifications,
        _navigatorKey = navigatorKey;

  StreamSubscription<ReceivedAction> _actionStream;

  List<String> _notificationMessages = [];
  String _soundSourcePath = Constants.soundSourceArray[0];

  Future init() async {
    await _awesomeLocalNotifications
        .initialize('resource://drawable/norbu_notific_large', []);

    await _awesomeLocalNotifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        _awesomeLocalNotifications.requestPermissionToSendNotifications();
      }
    });

    _actionStream =
        _awesomeLocalNotifications.actionStream.listen((receivedNotification) {
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
    _navigatorKey.currentState.pushNamedAndRemoveUntil(targetPage,
        (route) => (route.settings.name != targetPage) || route.isFirst,
        arguments: receivedNotification);
  }

  //if press button
  void processSettingsControls(ReceivedAction receivedNotification) {
    String targetPage;
    targetPage = PAGE_SETTINGS;

    _navigatorKey.currentState.pushNamedAndRemoveUntil(targetPage,
        (route) => (route.settings.name != targetPage) || route.isFirst);
  }

  Future<void> setupChannelAwarness({
    int soundSource,
  }) async {
    if (soundSource < 3) {
      _soundSourcePath = Constants.soundSourceArray[soundSource];

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
    int intervalSource,
    int intervalValue,
    TimeOfDay timeFrom,
    TimeOfDay timeUntil,
    bool isTimeOnActivated,
    List<String> messagesList,
    NotificationImportance importance,
  }) async {
    await cancelNotificationsTaskForChannelAwareness();
    List<int> listTimeFrom = [timeFrom.hour, timeFrom.minute];
    List<int> listTimeUntil = [timeUntil.hour, timeUntil.minute];

    DataTimer dataTimerTask = DataTimer(
        intervalSource: intervalSource,
        intervalValue: intervalValue,
        timeFrom: listTimeFrom,
        timeUntil: listTimeUntil,
        soundSourcePath: _soundSourcePath,
        messages: messagesList,
        isTimeOnActivated: isTimeOnActivated);

    int intervalDelay = DateTimeUtil.intervalDelayInSeconds(
        intervalValue: intervalValue,
        timeFrom: listTimeFrom,
        timeUntil: listTimeUntil,
        intervalSource: intervalSource,
        isTimeOnActivated: isTimeOnActivated);

    Workmanager().registerOneOffTask(
      tagAwaTask,
      channelAwarenessDelayedTask,
      inputData: dataTimerTask.toMap(),
      initialDelay: Duration(seconds: intervalDelay),
    );

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
    //await cancelSchedule(1);
    await cancelNotification(idAwa);
    await Workmanager().cancelAll();
  }
}
