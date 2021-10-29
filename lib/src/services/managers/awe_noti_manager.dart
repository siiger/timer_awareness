import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:norbu_timer/main.dart';
import 'package:norbu_timer/service_locator.dart';
import 'package:norbu_timer/src/common_widgets/notifications_home_page.dart';
import 'package:norbu_timer/src/config/routes.dart';
import 'package:norbu_timer/src/core/utils/date_time_util.dart';
import 'package:norbu_timer/src/features/timer/timer_screen.dart';
import 'package:norbu_timer/src/features/timer/util/timer_strings_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

class NotificationManager {
  static const int notiMindfulnessId = 0;
  static const String channelMindfulnessKey = 'Mindfulness';
  static const String channelMindfulnessName = 'Norbu_Timer';
  static const String channelMindfulnessDescription = 'Timer settinings';

  static NotificationManager instance;

  static final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

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
  StreamSubscription<ReceivedAction> _actionStream;

  static NotificationManager getInstance() {
    return instance;
  }

  NotificationManager() {
    if (instance != null) throw new Exception(["_EXC_"]);

    instance = this;
  }

  Future<void> init() async {
    await awesomeNotifications.initialize('resource://drawable/res_norbu_notific', []);

    await awesomeNotifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        awesomeNotifications.requestPermissionToSendNotifications();
      }
    });

    _actionStream = awesomeNotifications.actionStream.listen((receivedNotification) {
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
    String targetPage;
    targetPage = PAGE_NOTIFICATION_HOME;
    Logger.root.fine('FirebaseMessaging: onSelectNotification: Notification received. Navigate to home.');
    // Avoid to open the notification details page over another details page already opened
    navigator.currentState.pushNamedAndRemoveUntil(targetPage, (route) => false);
  }

  //if press button
  void processSettingsControls(ReceivedAction receivedNotification) {
    String targetPage;
    targetPage = PAGE_SETTINGS;
    //navigator.currentState.pushNamedAndRemoveUntil(targetPage, (route) => false, arguments: "timer0");
    navigator.currentState.pushNamed(targetPage, arguments: "timer0");
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
    await awesomeNotifications.createNotification(
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
  }

  Future<void> _setChannelSpecific({
    int soundSource,
  }) async {
    if (soundSource < 3) {
      String _soundSourcePath = TimerStringsUtil.soundSourceArray[soundSource];

      await awesomeNotifications.setChannel(NotificationChannel(
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
      await awesomeNotifications.setChannel(NotificationChannel(
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
    await awesomeNotifications.removeChannel(channelKey);
  }

  Future<void> cancelSchedule(int id) async {
    await awesomeNotifications.cancelSchedule(id);
  }

  Future<void> cancelAllSchedules() async {
    await awesomeNotifications.cancelAllSchedules();
  }

  Future<void> cancelNotification(int id) async {
    await awesomeNotifications.cancel(id);
  }

  Future<void> cancelNotificationsMindfulness() async {
    await awesomeNotifications.cancel(notiMindfulnessId);
    await awesomeNotifications.cancelSchedule(notiMindfulnessId);
    await awesomeNotifications.removeChannel(channelMindfulnessKey);
  }
}
