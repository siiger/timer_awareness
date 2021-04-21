import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
//import 'package:timer_awareness/utils/notification_util.dart';
import 'package:timer_awareness/routes.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timer_awareness/main.dart';
import 'package:intl/intl.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationService extends Bloc<NotificationEvent, NotificationState> {
  List<int> listRanInter;
  String date;
  NotificationService({this.navigatorKey})
      : super(NotificationState(
          isActive: false,
          isCallingMode: false,
          isFlightMode: false,
          isMusicPlaying: false,
          intervalSource: 0,
          vibrationLevel: 0,
          isTimeOff: false,
          isSilentMode: false,
          preciseInterval: 1,
          randomIntervalMin: 1,
          randomIntervalMax: 5,
          soundSource: 0,
          daysSelected: [true, true, true, true, true, true, true],
          dayssh: true,
        )) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      if (!StringUtils.isNullOrEmpty(receivedNotification.buttonKeyInput)) {
        processInputTextReceived(receivedNotification);
      } else {
        processDefaultActionReceived(receivedNotification);
      }
    });
    listRanInter = new List<int>.generate(50, (i) => random(1, 5));
    date = DateFormat('3 0/1 * * * ? *').format(DateTime.now().toUtc());
  }

  final GlobalKey<NavigatorState> navigatorKey;
  final int iid = 1;
  final String channelKey = 'channelKey';
  final String soundSource1 = 'resource://raw/rhy_bre_sound3_hold';
  final List<Int64List> listVibPattern = [
    null,
    lowVibrationPattern,
    mediumVibrationPattern,
    highVibrationPattern
  ];

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is ToggleNotificationService) {
      yield* _mapToggleNotificationServiceToState(state);
    } else if (event is ChangedPreciseInterval) {
      yield* _mapChangedPreciseIntervalToState(state, event);
    } else if (event is ChangedRandomMinInterval) {
      yield* _mapChangedRandomMinIntervalToState(state, event);
    } else if (event is ChangedRandomMaxInterval) {
      yield* _mapChangedRandomMaxIntervalToState(state, event);
    } else if (event is ToggleSoundSource) {
      yield* _mapToggleSoundSourceToState(state, event);
    } else if (event is ToggleOffDaysPerWeek) {
      yield* _mapToggleOffDaysPerWeekToState(state, event);
    } else if (event is ToggleOffTimePerDay) {
      yield* _mapToggleOffTimePerDayToState(state, event);
    } else if (event is ToggleOffWhenFlightMode) {
      yield* _mapToggleOffWhenFlightModeToState(state, event);
    } else if (event is ToggleOffWhenCallingMode) {
      yield* _mapToggleOffWhenCallingModeToState(state, event);
    } else if (event is ToggleOffWhenMusicPlaying) {
      yield* _mapToggleOffWhenMusicPlayingToState(state, event);
    } else if (event is ToggleOffWhenSilentMode) {
      yield* _mapToggleOffWhenSilentModeToState(state, event);
    } else if (event is ToggleIntervalSource) {
      yield* _mapToggleIntervalSourceToState(state, event);
    } else if (event is ToggleVibrationLevel) {
      yield* _mapToggleVibrationLevelToState(state, event);
    } else if (event is ChangedTimeOffFrom) {
      yield* _mapChangedTimeOffFromToState(state, event);
    } else if (event is ChangedTimeOffUntil) {
      yield* _mapChangedTimeOffUntilToState(state, event);
    }
  }

  Stream<NotificationState> _mapToggleNotificationServiceToState(
      NotificationState state) async* {
    if (!state.isActive) {
      date = '0 0/${state.preciseInterval} * * * ? *';
      await showNotification(
          id: iid,
          intervalSource: state.intervalSource,
          preciseDate: date,
          listRanInter: listRanInter,
          soundSource: state.soundSource,
          vibrationLevel: state.vibrationLevel,
          importance: NotificationImportance.High);
      yield state.copyWith(isActive: true);
    } else {
      await cancelSchedule(iid);
      yield state.copyWith(isActive: false);
    }
  }

  Stream<NotificationState> _mapChangedPreciseIntervalToState(
      NotificationState state, ChangedPreciseInterval event) async* {
    if (state.isActive) {
      await cancelSchedule(iid);
      date = '0 0/${event.interval} * * * ? *';
      await showNotification(
          id: iid,
          intervalSource: state.intervalSource,
          preciseDate: date,
          listRanInter: listRanInter,
          soundSource: state.soundSource,
          vibrationLevel: state.vibrationLevel,
          importance: NotificationImportance.High);
      yield state.copyWith(preciseInterval: event.interval);
    }
  }

  Stream<NotificationState> _mapChangedRandomMinIntervalToState(
      NotificationState state, ChangedRandomMinInterval event) async* {
    if (state.isActive) {
      await cancelSchedule(iid);
      listRanInter = new List<int>.generate(
          50, (i) => random(event.intervalMin, state.randomIntervalMax));
      await showNotification(
          id: iid,
          intervalSource: state.intervalSource,
          preciseDate: date,
          listRanInter: listRanInter,
          soundSource: state.soundSource,
          vibrationLevel: state.vibrationLevel,
          importance: NotificationImportance.High);
      yield state.copyWith(randomIntervalMin: event.intervalMin);
    }
  }

  Stream<NotificationState> _mapChangedRandomMaxIntervalToState(
      NotificationState state, ChangedRandomMaxInterval event) async* {
    if (state.isActive) {
      await cancelSchedule(iid);
      listRanInter = new List<int>.generate(
          50, (i) => random(state.randomIntervalMin, event.intervalMax));
      await showNotification(
          id: iid,
          intervalSource: state.intervalSource,
          preciseDate: date,
          listRanInter: listRanInter,
          soundSource: state.soundSource,
          vibrationLevel: state.vibrationLevel,
          importance: NotificationImportance.High);
      yield state.copyWith(randomIntervalMax: event.intervalMax);
    }
  }

  Stream<NotificationState> _mapChangedTimeOffFromToState(
      NotificationState state, ChangedTimeOffFrom event) async* {
    if (state.isActive) {
      await cancelSchedule(iid);
      date = '0 0/${state.preciseInterval} * * * ? *';
      await showNotification(
          id: iid,
          intervalSource: state.intervalSource,
          preciseDate: date,
          listRanInter: listRanInter,
          soundSource: state.soundSource,
          vibrationLevel: state.vibrationLevel,
          importance: NotificationImportance.High);
      yield state.copyWith(timeFrom: event.timeFrom);
    }
  }

  Stream<NotificationState> _mapChangedTimeOffUntilToState(
      NotificationState state, ChangedTimeOffUntil event) async* {
    if (state.isActive) {
      await cancelSchedule(iid);
      date = '0 0/${state.preciseInterval} * * * ? *';
      await showNotification(
          id: iid,
          intervalSource: state.intervalSource,
          preciseDate: date,
          listRanInter: listRanInter,
          soundSource: state.soundSource,
          vibrationLevel: state.vibrationLevel,
          importance: NotificationImportance.High);
      yield state.copyWith(timeUntil: event.timeUntil);
    }
  }

  Stream<NotificationState> _mapToggleSoundSourceToState(
      NotificationState state, ToggleSoundSource event) async* {
    if (state.isActive) {
      await cancelSchedule(iid);
      await showNotification(
          id: iid,
          intervalSource: state.intervalSource,
          preciseDate: date,
          listRanInter: listRanInter,
          soundSource: event.value,
          vibrationLevel: state.vibrationLevel,
          importance: NotificationImportance.High);
      yield state.copyWith(soundSource: event.value);
    }
  }

  Stream<NotificationState> _mapToggleIntervalSourceToState(
      NotificationState state, ToggleIntervalSource event) async* {
    if (state.isActive) {
      await cancelSchedule(iid);
      await showNotification(
          id: iid,
          intervalSource: event.value,
          preciseDate: date,
          listRanInter: listRanInter,
          soundSource: state.soundSource,
          vibrationLevel: state.vibrationLevel,
          importance: NotificationImportance.High);
      yield state.copyWith(intervalSource: event.value);
    }
  }

  Stream<NotificationState> _mapToggleVibrationLevelToState(
      NotificationState state, ToggleVibrationLevel event) async* {
    if (state.isActive) {
      await cancelSchedule(iid);
      await showNotification(
          id: iid,
          intervalSource: state.intervalSource,
          preciseDate: date,
          listRanInter: listRanInter,
          soundSource: state.soundSource,
          vibrationLevel: event.value,
          importance: NotificationImportance.High);
      yield state.copyWith(vibrationLevel: event.value);
    }
  }

  Stream<NotificationState> _mapToggleOffDaysPerWeekToState(
      NotificationState state, ToggleOffDaysPerWeek event) async* {
    if (state.isActive) {
      final List<bool> selectDay = state.daysSelected;
      selectDay.replaceRange(
          event.index, event.index + 1, [!state.daysSelected[event.index]]);
      await cancelSchedule(iid);
      date = '0 0/${state.preciseInterval} * * * ? *';
      await showNotification(
          id: iid,
          intervalSource: state.intervalSource,
          preciseDate: date,
          listRanInter: listRanInter,
          soundSource: state.soundSource,
          vibrationLevel: state.vibrationLevel,
          importance: NotificationImportance.High);
      yield state.copyWith(daysSelected: selectDay, dayssh: !state.dayssh);
    }
  }

  Stream<NotificationState> _mapToggleOffTimePerDayToState(
      NotificationState state, ToggleOffTimePerDay event) async* {
    if (state.isActive) {
      if (!state.isTimeOff) {
        date = '0 0/${state.preciseInterval} * * * ? *';
        //await showNotification(3, date, channelNameKey[state.soundSource]);
        yield state.copyWith(isTimeOff: true);
      } else {
        //await cancelSchedule(3);
        //await event.device.disconnect();
        yield state.copyWith(isTimeOff: false);
      }
    }
  }

  Stream<NotificationState> _mapToggleOffWhenFlightModeToState(
      NotificationState state, ToggleOffWhenFlightMode event) async* {
    if (state.isActive) {
      if (!state.isFlightMode) {
        date = '0 0/${state.preciseInterval} * * * ? *';
        //await showNotification(3, date, channelNameKey[state.soundSource]);
        yield state.copyWith(isFlightMode: true);
      } else {
        //await cancelSchedule(3);
        //await event.device.disconnect();
        yield state.copyWith(isFlightMode: false);
      }
    }
  }

  Stream<NotificationState> _mapToggleOffWhenCallingModeToState(
      NotificationState state, ToggleOffWhenCallingMode event) async* {
    if (state.isActive) {
      if (!state.isCallingMode) {
        date = '0 0/${state.preciseInterval} * * * ? *';
        //await showNotification(3, date, channelNameKey[state.soundSource]);
        yield state.copyWith(isCallingMode: true);
      } else {
        //await cancelSchedule(3);
        //await event.device.disconnect();
        yield state.copyWith(isCallingMode: false);
      }
    }
  }

  Stream<NotificationState> _mapToggleOffWhenMusicPlayingToState(
      NotificationState state, ToggleOffWhenMusicPlaying event) async* {
    if (state.isActive) {
      if (!state.isMusicPlaying) {
        date = '0 0/${state.preciseInterval} * * * ? *';
        //await showNotification(3, date, channelNameKey[state.soundSource]);
        yield state.copyWith(isMusicPlaying: true);
      } else {
        //await cancelSchedule(3);
        //await event.device.disconnect();
        yield state.copyWith(isMusicPlaying: false);
      }
    }
  }

  Stream<NotificationState> _mapToggleOffWhenSilentModeToState(
      NotificationState state, ToggleOffWhenSilentMode event) async* {
    if (state.isActive) {
      if (!state.isSilentMode) {
        date = '0 0/${state.preciseInterval} * * * ? *';
        //await showNotification(3, date, channelNameKey[state.soundSource]);
        yield state.copyWith(isSilentMode: true);
      } else {
        //await cancelSchedule(3);
        //await event.device.disconnect();
        yield state.copyWith(isSilentMode: false);
      }
    }
  }

  int random(min, max) {
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }

  void processDefaultActionReceived(ReceivedAction receivedNotification) {
    Fluttertoast.showToast(msg: 'Action received');
    String targetPage;
    targetPage = PAGE_NOTIFICATION_DETAILS;
    // Avoid to open the notification details page over another details page already opened
    navigatorKey.currentState.pushNamedAndRemoveUntil(targetPage,
        (route) => (route.settings.name != targetPage) || route.isFirst,
        arguments: receivedNotification);
  }

  void processInputTextReceived(ReceivedAction receivedNotification) {
    Fluttertoast.showToast(
        msg: 'Msg: ' + receivedNotification.buttonKeyInput,
        backgroundColor: App.mainColor,
        textColor: Colors.white);
  }

  Future<void> showNotification({
    int id,
    int intervalSource,
    List<int> listRanInter,
    String preciseDate,
    int vibrationLevel,
    int soundSource,
    NotificationImportance importance,
  }) async {
    bool enblVibr = false;
    bool playSound = true;
    String soundSourcePath;
    if (vibrationLevel > 0) enblVibr = true;
    if (soundSource == 1) {
      soundSourcePath = soundSource1;
    } else if (soundSource == 2) {
      playSound = false;
    }
    await AwesomeNotifications().setChannel(NotificationChannel(
      channelKey: channelKey,
      channelName: '--',
      channelDescription: '--',
      channelShowBadge: false,
      playSound: playSound,
      soundSource: soundSourcePath,
      enableVibration: enblVibr,
      vibrationPattern: listVibPattern[vibrationLevel],
      importance: importance,
    ));

    NotificationSchedule schel;
    if (intervalSource == 0) {
      schel = NotificationSchedule(crontabSchedule: preciseDate);
    } else if (intervalSource == 1) {
      schel = NotificationSchedule(
          preciseSchedules: listRanInter
              .map((e) => DateTime.now().add(Duration(minutes: e)).toUtc())
              .toList());
    }

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: channelKey,
            title: 'App:',
            body: 'Be awareness!',
            payload: {'uuid': 'user-profile-uuid'}),
        actionButtons: [
          NotificationActionButton(
            key: 'LINK',
            label: 'Link',
            autoCancel: true,
            buttonType: ActionButtonType.InputField,
          )
        ],
        schedule: schel);
  }

  Future<void> removeChannel() async {
    AwesomeNotifications().removeChannel(channelKey);
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
}
