import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:norbu_timer/src/core/utils/date_time_util.dart';
import 'package:norbu_timer/src/features/timer/util/timer_strings_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

class NotificationManager {
  static const int notiMindfulnessId = 0;
  static const String channelMindfulnessKey = 'Awareness';
  static const String channelMindfulnessName = 'Awareness_Timer';
  static const String channelMindfulnessDescription = 'Timer settinings';

  static NotificationManager _instance;

  final _log = Logger('NotificationService');

  List<String> timerListMessages;
  List<String> timerListCheckMessages;
  int intervalTimeOfLunchBackgrFetch;
  int hourFrom;
  int minuteFrom;
  TimeOfDay timerTimeFrom;
  int hourUntil;
  int minuteUntil;
  TimeOfDay timerTimeUntil;
  int timerIntervalSource;
  bool isTimerTimeOff;
  int timerSoundSource;
  String notificationLabelButton;
  String notificationBody;

  SharedPreferences preferences;
  Stream<ReceivedAction> get actionStream => AwesomeNotifications().actionStream;

  static Future<NotificationManager> getInstance() async {
    if (_instance == null) {
      _instance = NotificationManager();
      await _instance._init();
    }
    return _instance;
  }

  NotificationManager() {
    if (_instance != null) throw new Exception(["_EXC_"]);

    _instance = this;
  }

  Future<void> _init() async {
    await AwesomeNotifications().initialize('resource://drawable/res_ic_launcher_foreground', []);

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> _loadSharedPreferences() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  Future<void> _updateArgs() async {
    if (this.preferences == null) await _loadSharedPreferences();

    this.timerListMessages = preferences.getStringList('timerMessages');
    this.timerListCheckMessages = preferences.getStringList('checkMessages');
    this.intervalTimeOfLunchBackgrFetch = preferences.getInt('intervalValue');
    this.hourFrom = preferences.getInt('timeFromKeyHour');
    this.minuteFrom = preferences.getInt('timeFromKeyMinute');
    this.timerTimeFrom = TimeOfDay(hour: this.hourFrom, minute: this.minuteFrom);
    this.hourUntil = preferences.getInt('timeUntilKeyHour');
    this.minuteUntil = preferences.getInt('timeUntilKeyMinute');
    this.timerTimeUntil = TimeOfDay(hour: this.hourUntil, minute: this.minuteUntil);
    this.timerIntervalSource = preferences.getInt('intervalSource');
    this.isTimerTimeOff = preferences.getBool('isTimeOff');
    this.timerSoundSource = preferences.getInt('soundSource');
    this.notificationLabelButton = preferences.getString('notificationLabelButton');
    this.notificationBody = preferences.getString('notificationBody');
  }

  String _getMessage() {
    List<String> messageListResault = [];
    for (int i = 0; i < this.timerListMessages.length; i++) {
      if (this.timerListCheckMessages.contains(i.toString())) messageListResault..add(this.timerListMessages[i]);
    }

    String messageResault = ' ';
    if (messageListResault.isNotEmpty) {
      if (messageListResault.length > 1) {
        var index = Random().nextInt(messageListResault.length);
        messageResault = messageListResault[index];
      } else if (messageListResault.length == 1) {
        messageResault = messageListResault[0];
      }
    }
    return messageResault;
  }

  Future<void> updateNotifications() async {
    await _updateArgs();

    DateTime currentTime = DateTime.now();
    DateTime timeOfAppearing = DateTimeUtil.nextTime(
        currentTime: currentTime,
        intervalValue: this.intervalTimeOfLunchBackgrFetch,
        timeFrom: this.timerTimeFrom,
        timeUntil: this.timerTimeUntil,
        intervalSource: this.timerIntervalSource,
        isTimeOnActivated: this.isTimerTimeOff);

    int intervalDelay = timeOfAppearing.difference(currentTime).inMinutes;

    if (intervalDelay <= this.intervalTimeOfLunchBackgrFetch) {
      String message = _getMessage();
      timeOfAppearing = timeOfAppearing.add(Duration(minutes: -1));
      await _setChannelSpecific(soundSource: this.timerSoundSource);
      await _createNotification(message: message, timeOfAppearing: timeOfAppearing);
    }
  }

  Future<void> _createNotification({
    String message,
    DateTime timeOfAppearing,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notiMindfulnessId,
        channelKey: channelMindfulnessKey,
        title: message,
        body: this.notificationBody,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'Settings_Timer',
          label: this.notificationLabelButton,
          autoCancel: true,
          buttonType: ActionButtonType.Default,
        )
      ],
      schedule: NotificationCalendar.fromDate(date: timeOfAppearing.toUtc()),
    );
    _log.fine('Schedule notification at $timeOfAppearing');
  }

  Future<void> _setChannelSpecific({
    int soundSource,
  }) async {
    if (soundSource < 3) {
      String _soundSourcePath = TimerStringsUtil.soundSourceArray[soundSource];

      await AwesomeNotifications().setChannel(NotificationChannel(
        channelKey: channelMindfulnessKey,
        channelName: channelMindfulnessName,
        channelDescription: channelMindfulnessDescription,
        channelShowBadge: false,
        playSound: true,
        soundSource: _soundSourcePath,
        enableVibration: false,
        importance: NotificationImportance.High,
      ));
    } else if (soundSource == 3) {
      await AwesomeNotifications().setChannel(NotificationChannel(
          channelKey: channelMindfulnessKey,
          channelName: channelMindfulnessName,
          channelDescription: channelMindfulnessDescription,
          channelShowBadge: false,
          enableVibration: false,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          importance: NotificationImportance.High));
    }
  }

  Future<void> removeChannel(String channelKey) async {
    await AwesomeNotifications().removeChannel(channelKey);
  }

  Future<void> cancelSchedule(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }

  Future<void> cancelAllSchedules() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancel(notiMindfulnessId);
    await AwesomeNotifications().cancelSchedule(notiMindfulnessId);
    await AwesomeNotifications().removeChannel(channelMindfulnessKey);
  }
}
