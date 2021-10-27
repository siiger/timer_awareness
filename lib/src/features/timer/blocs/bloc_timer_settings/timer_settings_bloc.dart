import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:norbu_timer/src/services/notification_service.dart';
import 'package:norbu_timer/src/features/timer/util/timer_strings_util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:norbu_timer/service_locator.dart';
import 'package:norbu_timer/src/services/local_storage_service.dart';

part 'timer_settings_event.dart';
part 'timer_settings_state.dart';

class NotificationTimerSettings extends Bloc<TimerSettingsEvent, TimerSettingsState> {
  final NotificationService _notificationService;
  final AudioPlayer _audioPlayer;

  NotificationTimerSettings({@required NotificationService notificationService, @required AudioPlayer audioPlayer})
      : assert(notificationService != null, audioPlayer != null),
        _notificationService = notificationService,
        _audioPlayer = audioPlayer,
        super(TimerSettingsState(
            isActive: sl<LocalStorageService>().isActivePre,
            isCallingMode: false,
            isFlightMode: false,
            isMusicPlaying: false,
            intervalSource: sl<LocalStorageService>().intervalSourcePre,
            isTimeOff: sl<LocalStorageService>().isTimeOffPre,
            isSilentMode: false,
            timeFrom: sl<LocalStorageService>().timeFrom,
            timeUntil: sl<LocalStorageService>().timeUntil,
            preciseInterval: sl<LocalStorageService>().intervalPre,
            currentSliderVolume: sl<LocalStorageService>().sliderValuePre,
            soundSource: sl<LocalStorageService>().soundSourcePre,
            messages: sl<LocalStorageService>().listMessagesPre,
            checkMessages: sl<LocalStorageService>().listCheckMessagesPre));

  @override
  Stream<TimerSettingsState> mapEventToState(
    TimerSettingsEvent event,
  ) async* {
    if (event is ToggleNotificationService) {
      yield* _mapToggleNotificationServiceToState(state);
    } else if (event is ChangedPreciseInterval) {
      yield* _mapChangedPreciseIntervalToState(state, event);
    } else if (event is ChangedSliderVolume) {
      yield* _mapChangedSliderVolumeToState(state, event);
    } else if (event is ToggleSoundSource) {
      yield* _mapToggleSoundSourceToState(state, event);
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
    } else if (event is ChangedTimeOffFrom) {
      yield* _mapChangedTimeOffFromToState(state, event);
    } else if (event is ChangedTimeOffUntil) {
      yield* _mapChangedTimeOffUntilToState(state, event);
    } else if (event is ChangedMessages) {
      yield* _mapChangedMessagesToState(state, event);
    } else if (event is CheckMessage) {
      yield* _mapCheckMessageToState(state, event);
    } else if (event is InitSettings) {
      yield* _mapInitSettingsToState(state, event);
    }
  }

  Stream<TimerSettingsState> _mapInitSettingsToState(TimerSettingsState state, InitSettings event) async* {
    await _notificationService.setupChannelAwarness(soundSource: state.soundSource);
  }

  Future<ByteData> _loadAsset(String soundPath) async {
    return await rootBundle.load("assets/" + soundPath);
  }

  _playLocal(int soundSource) async {
    if (soundSource < 3) {
      List<String> soundPath = TimerStringsUtil.soundSourceArray[soundSource].split("/");
      //await audioCache.play(soundPath[3] + ".mp3");
      final file = new File('${(await getTemporaryDirectory()).path}/${soundPath[3] + ".mp3"}');
      await file.writeAsBytes((await _loadAsset(soundPath[3] + ".mp3")).buffer.asUint8List());
      final result = await _audioPlayer.play(file.path, isLocal: true);
    } else if (soundSource == 3) {
      await _audioPlayer.stop();
      await FlutterRingtonePlayer.playNotification();
    }
  }

  Stream<TimerSettingsState> _mapToggleNotificationServiceToState(TimerSettingsState state) async* {
    if (!state.isActive) {
      _notificationService.setupNotificationMessages(messages: state.messages);
      yield state.copyWith(isActive: true);
      await sl<LocalStorageService>().setActive(true);

      await _notificationService.setupNotificationsTaskForChannelAwareness(intervalValue: state.preciseInterval);
    } else {
      yield state.copyWith(isActive: false);
      await sl<LocalStorageService>().setActive(false);
      await _notificationService.cancelNotificationsTaskForChannelAwareness();
    }
  }

  Stream<TimerSettingsState> _mapChangedPreciseIntervalToState(
      TimerSettingsState state, ChangedPreciseInterval event) async* {
    yield state.copyWith(preciseInterval: TimerStringsUtil.timeIntervals[event.interval]);
    await sl<LocalStorageService>().setInterval(TimerStringsUtil.timeIntervals[event.interval]);

    if (state.isActive) {
      await _notificationService.setupNotificationsTaskForChannelAwareness(
          intervalValue: TimerStringsUtil.timeIntervals[event.interval]);
    }
  }

  Stream<TimerSettingsState> _mapChangedSliderVolumeToState(
      TimerSettingsState state, ChangedSliderVolume event) async* {
    yield state.copyWith(currentSliderVolume: event.volume);
    await sl<LocalStorageService>().setSliderVolume(event.volume);
  }

  Stream<TimerSettingsState> _mapChangedMessagesToState(TimerSettingsState state, ChangedMessages event) async* {
    List<String> mes = state.messages..replaceRange(event.index, event.index + 1, [event.message]);

    yield state.copyWith(messages: mes);
    await sl<LocalStorageService>().setMessages(mes);

    //_notificationService.setupNotificationMessages(messages: mes);
  }

  Stream<TimerSettingsState> _mapCheckMessageToState(TimerSettingsState state, CheckMessage event) async* {
    List<String> checkMess;
    if (state.checkMessages.contains(event.index.toString())) {
      checkMess = [...state.checkMessages]..remove(event.index.toString());
    } else {
      checkMess = [...state.checkMessages]..add(event.index.toString());
    }

    yield state.copyWith(checkMessages: checkMess);
    await sl<LocalStorageService>().setCheckMessages(checkMess);
  }

  Stream<TimerSettingsState> _mapChangedTimeOffFromToState(TimerSettingsState state, ChangedTimeOffFrom event) async* {
    await sl<LocalStorageService>().setTimeOffFrom(event.timeFrom);
    yield state.copyWith(timeFrom: event.timeFrom);
    if (state.isActive) {
      await _notificationService.setupNotificationsTaskForChannelAwareness(
          intervalValue: TimerStringsUtil.timeIntervals[state.preciseInterval]);
    }
  }

  Stream<TimerSettingsState> _mapChangedTimeOffUntilToState(
      TimerSettingsState state, ChangedTimeOffUntil event) async* {
    await sl<LocalStorageService>().setTimeOffUntil(event.timeUntil);
    yield state.copyWith(timeUntil: event.timeUntil);
    if (state.isActive) {
      await _notificationService.setupNotificationsTaskForChannelAwareness(
          intervalValue: TimerStringsUtil.timeIntervals[state.preciseInterval]);
    }
  }

  Stream<TimerSettingsState> _mapToggleSoundSourceToState(TimerSettingsState state, ToggleSoundSource event) async* {
    await _playLocal(event.value);
    yield state.copyWith(soundSource: event.value);
    await sl<LocalStorageService>().setSoundSource(event.value);
    await _notificationService.setupChannelAwarness(soundSource: event.value);
  }

  Stream<TimerSettingsState> _mapToggleIntervalSourceToState(
      TimerSettingsState state, ToggleIntervalSource event) async* {
    yield state.copyWith(intervalSource: event.value);
    await sl<LocalStorageService>().setIntervalSource(event.value);
  }

  Stream<TimerSettingsState> _mapToggleOffTimePerDayToState(
      TimerSettingsState state, ToggleOffTimePerDay event) async* {
    if (!state.isTimeOff) {
      yield state.copyWith(isTimeOff: true);
      await sl<LocalStorageService>().setTimeOffPerDay(true);
    } else {
      yield state.copyWith(isTimeOff: false);
      await sl<LocalStorageService>().setTimeOffPerDay(false);
    }

    if (state.isActive) {
      await _notificationService.setupNotificationsTaskForChannelAwareness(
          intervalValue: TimerStringsUtil.timeIntervals[state.preciseInterval]);
    }
  }

  Stream<TimerSettingsState> _mapToggleOffWhenFlightModeToState(
      TimerSettingsState state, ToggleOffWhenFlightMode event) async* {
    if (state.isActive) {
      if (!state.isFlightMode) {
        String date = '0 0/${state.preciseInterval} * * * ? *';
        //await showNotification(3, date, channelNameKey[state.soundSource]);
        yield state.copyWith(isFlightMode: true);
      } else {
        //await cancelSchedule(3);
        //await event.device.disconnect();
        yield state.copyWith(isFlightMode: false);
      }
    }
  }

  Stream<TimerSettingsState> _mapToggleOffWhenCallingModeToState(
      TimerSettingsState state, ToggleOffWhenCallingMode event) async* {
    if (state.isActive) {
      if (!state.isCallingMode) {
        String date = '0 0/${state.preciseInterval} * * * ? *';
        //await showNotification(3, date, channelNameKey[state.soundSource]);
        yield state.copyWith(isCallingMode: true);
      } else {
        //await cancelSchedule(3);
        //await event.device.disconnect();
        yield state.copyWith(isCallingMode: false);
      }
    }
  }

  Stream<TimerSettingsState> _mapToggleOffWhenMusicPlayingToState(
      TimerSettingsState state, ToggleOffWhenMusicPlaying event) async* {
    if (state.isActive) {
      if (!state.isMusicPlaying) {
        String date = '0 0/${state.preciseInterval} * * * ? *';
        //await showNotification(3, date, channelNameKey[state.soundSource]);
        yield state.copyWith(isMusicPlaying: true);
      } else {
        //await cancelSchedule(3);
        //await event.device.disconnect();
        yield state.copyWith(isMusicPlaying: false);
      }
    }
  }

  Stream<TimerSettingsState> _mapToggleOffWhenSilentModeToState(
      TimerSettingsState state, ToggleOffWhenSilentMode event) async* {
    if (state.isActive) {
      if (!state.isSilentMode) {
        String date = '0 0/${state.preciseInterval} * * * ? *';
        //await showNotification(3, date, channelNameKey[state.soundSource]);
        yield state.copyWith(isSilentMode: true);
      } else {
        //await cancelSchedule(3);
        //await event.device.disconnect();
        yield state.copyWith(isSilentMode: false);
      }
    }
  }
}
