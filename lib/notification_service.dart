import 'dart:async';
import 'dart:math';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timer_awareness/routes.dart';
import 'package:timer_awareness/core/constants.dart';

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

  final String channelAwareness = 'awareness';
  final String channelDaily = 'daily';

  List<String> _notificationMessages = [];

  Isolate _isolate;
  ReceivePort _receivePort;

  var rn = new Random();

  static const String _notificationsChannelId = 'app.norbu.notification';
  static const String _notificationsChannelName = 'Norbu notifications';
  static const String _notificationsChannelDescr = 'Daily notifications';
  static const String _notificationsIconSmall = 'norbu_notific';
  static const String _notificationsIconLarge = 'norbu_notific_large';

  void dispose() {
    _actionStream.cancel();
  }

  Future init() async {
    await _awesomeLocalNotifications
        .initialize('resource://drawable/res_app_icon', []);

    await _awesomeLocalNotifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        _awesomeLocalNotifications.requestPermissionToSendNotifications();
      }
    });

    await setupChannelAwarness();

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

  void processDefaultActionReceived(ReceivedAction receivedNotification) {
    //Fluttertoast.showToast(msg: 'Action received');
    String targetPage;
    targetPage = PAGE_NOTIFICATION_HOME;
    // Avoid to open the notification details page over another details page already opened
    _navigatorKey.currentState.pushNamedAndRemoveUntil(targetPage,
        (route) => (route.settings.name != targetPage) || route.isFirst,
        arguments: receivedNotification);
  }

  void processSettingsControls(ReceivedAction receivedNotification) {
    String targetPage;
    targetPage = PAGE_SETTINGS;

    _navigatorKey.currentState.pushNamedAndRemoveUntil(targetPage,
        (route) => (route.settings.name != targetPage) || route.isFirst);
  }

  Future<void> updateSoundSourceForChannelAwarness({
    int soundSource,
  }) async {
    String soundSourcePath = Constants.soundSourceArray[soundSource];

    await _awesomeLocalNotifications.setChannel(NotificationChannel(
      channelKey: channelAwareness,
      channelName: 'Awareness',
      channelDescription: 'Timer settinings',
      channelShowBadge: false,
      playSound: true,
      soundSource: soundSourcePath,
      enableVibration: false,
      importance: NotificationImportance.High,
    ));
  }

  Future<void> setupChannelAwarness() async {
    await _awesomeLocalNotifications.setChannel(NotificationChannel(
      channelKey: channelAwareness,
      channelName: 'Awareness',
      channelDescription: 'Timer settinings',
      channelShowBadge: false,
      playSound: true,
      soundSource: Constants.soundSourceArray[0],
      enableVibration: false,
      importance: NotificationImportance.High,
    ));
  }

  Future<void> showNotificationByListSchedule({
    List<DateTime> dateList,
    NotificationImportance importance,
  }) async {
    await cancelAllSchedulesForTimerAwareness();

    _receivePort = ReceivePort();
    //Isolate stream for handle notification when application is working,
    //if the app is terminated then will be executed schedule for '_awesomeLocalNotifications'
    _isolate =
        await Isolate.spawn(_checkTimer, [_receivePort.sendPort, dateList]);
    _receivePort.listen(_handleMessage, onDone: () {
      print("done!");
    });

    //_log.fine('Schedule notification at $notificationDateTime');
  }

  static void _checkTimer(List<Object> arguments) async {
    SendPort sendPort = arguments[0];
    List<DateTime> dateList = arguments[1];
    dateList.insert(0, DateTime.now().toUtc());
    List<DateTime> dateListSh = dateList;

    for (var i = 0; i <= dateList.length; i++) {
      await Future.delayed(
          Duration(
              milliseconds:
                  dateList[i + 1].difference(dateList[i]).inMilliseconds -
                      2000), () {
        dateListSh = dateListSh.sublist(1);
        print('SEND: ');
        sendPort.send(dateListSh);
      });
    }
  }

  void _handleMessage(dynamic data) async {
    var index = rn.nextInt(_notificationMessages.length);

    await _awesomeLocalNotifications.createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: channelAwareness,
            displayOnBackground: true,
            title: '${_notificationMessages[index]}',
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
        schedule: NotificationSchedule(preciseSchedules: data));
    print('RECEIVED: ');
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

  Future<void> cancelAllSchedulesForTimerAwareness() async {
    await cancelSchedule(1);
    await cancelNotification(1).then((value) {
      if (_isolate != null) {
        _receivePort.close();
        _isolate.kill(priority: Isolate.immediate);
        _isolate = null;
      }
    });
  }
}
