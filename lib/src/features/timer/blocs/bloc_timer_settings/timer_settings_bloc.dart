import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:norbu_timer/src/services/background_service.dart';
import 'package:norbu_timer/src/features/timer/util/timer_strings_util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:norbu_timer/src/services/local_storage_service.dart';

part 'timer_settings_event.dart';
part 'timer_settings_state.dart';

class TimerSettingsBloc extends Bloc<TimerSettingsEvent, TimerSettingsState> {
  final BackgroundService _backgroundService;
  final LocalStorageService _localStorageService;
  final AudioPlayer _audioPlayer;

  TimerSettingsBloc({
    @required BackgroundService backgroundService,
    @required AudioPlayer audioPlayer,
    @required LocalStorageService localStorageService,
  })  : assert(localStorageService != null, backgroundService != null),
        _backgroundService = backgroundService,
        _audioPlayer = audioPlayer,
        _localStorageService = localStorageService,
        super(TimerSettingsState(
            isActive: localStorageService.isTimerActived,
            intervalSource: localStorageService.timerIntervalSource,
            isTimeOff: localStorageService.isTimerTimeOff,
            timeFrom: localStorageService.timerTimeFrom,
            timeUntil: localStorageService.timerTimeUntil,
            preciseInterval: localStorageService.timerInterval,
            currentSliderVolume: localStorageService.timerSliderValue,
            soundSource: localStorageService.timerSoundSource,
            messages: localStorageService.timerListMessages,
            checkMessages: localStorageService.timerListCheckMessages));

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
    List<String> mes = _localStorageService.timerListMessages;
    yield state.copyWith(messages: mes);
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
      //_notificationService.setupNotificationMessages(messages: state.messages);
      yield state.copyWith(isActive: true);
      _localStorageService.setTimerActive = true;

      // Для backgroundFetchHeadlessTask чтобы строго задать переменные
      _localStorageService.setTimerInterval = state.preciseInterval;
      _localStorageService.setTimerSliderVolume = state.currentSliderVolume;
      _localStorageService.setTimerMessages = state.messages;
      _localStorageService.setTimerCheckMessages = state.checkMessages;
      await _localStorageService.setTimerTimeOffFrom(state.timeFrom);
      await _localStorageService.setTimerTimeOffUntil(state.timeUntil);
      _localStorageService.setTimerSoundSource = state.soundSource;
      _localStorageService.setTimerIntervalSource = state.intervalSource;
      _localStorageService.setTimerTimeOffPerDay = state.isTimeOff;
      _localStorageService.setNotificationLabelButton = TimerStringsUtil().notificationLabelButton;
      _localStorageService.setNotificationBody = TimerStringsUtil().notificationBody;
      //

      await _backgroundService.setupBackgroundTask(intervalValue: state.preciseInterval);
    } else {
      yield state.copyWith(isActive: false);
      _localStorageService.setTimerActive = false;
      await _backgroundService.cancelBackgroundTask();
    }
  }

  Stream<TimerSettingsState> _mapChangedPreciseIntervalToState(
      TimerSettingsState state, ChangedPreciseInterval event) async* {
    yield state.copyWith(preciseInterval: TimerStringsUtil.timeIntervals[event.interval]);
    _localStorageService.setTimerInterval = TimerStringsUtil.timeIntervals[event.interval];

    if (state.isActive) {
      await _backgroundService.setupBackgroundTask(intervalValue: TimerStringsUtil.timeIntervals[event.interval]);
    }
  }

  Stream<TimerSettingsState> _mapChangedSliderVolumeToState(
      TimerSettingsState state, ChangedSliderVolume event) async* {
    yield state.copyWith(currentSliderVolume: event.volume);
    _localStorageService.setTimerSliderVolume = event.volume;
  }

  Stream<TimerSettingsState> _mapChangedMessagesToState(TimerSettingsState state, ChangedMessages event) async* {
    List<String> mes = state.messages..replaceRange(event.index, event.index + 1, [event.message]);

    yield state.copyWith(messages: mes);
    _localStorageService.setTimerMessages = mes;

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
    _localStorageService.setTimerCheckMessages = checkMess;
  }

  Stream<TimerSettingsState> _mapChangedTimeOffFromToState(TimerSettingsState state, ChangedTimeOffFrom event) async* {
    await _localStorageService.setTimerTimeOffFrom(event.timeFrom);
    yield state.copyWith(timeFrom: event.timeFrom);
    if (state.isActive) {
      await _backgroundService.setupBackgroundTask(intervalValue: state.preciseInterval);
    }
  }

  Stream<TimerSettingsState> _mapChangedTimeOffUntilToState(
      TimerSettingsState state, ChangedTimeOffUntil event) async* {
    await _localStorageService.setTimerTimeOffUntil(event.timeUntil);
    yield state.copyWith(timeUntil: event.timeUntil);
    if (state.isActive) {
      await _backgroundService.setupBackgroundTask(intervalValue: state.preciseInterval);
    }
  }

  Stream<TimerSettingsState> _mapToggleSoundSourceToState(TimerSettingsState state, ToggleSoundSource event) async* {
    await _playLocal(event.value);
    yield state.copyWith(soundSource: event.value);
    _localStorageService.setTimerSoundSource = event.value;
    //await _notificationService.setupChannelAwarness(soundSource: event.value);
  }

  Stream<TimerSettingsState> _mapToggleIntervalSourceToState(
      TimerSettingsState state, ToggleIntervalSource event) async* {
    yield state.copyWith(intervalSource: event.value);
    _localStorageService.setTimerIntervalSource = event.value;
  }

  Stream<TimerSettingsState> _mapToggleOffTimePerDayToState(
      TimerSettingsState state, ToggleOffTimePerDay event) async* {
    if (!state.isTimeOff) {
      yield state.copyWith(isTimeOff: true);
      _localStorageService.setTimerTimeOffPerDay = true;
    } else {
      yield state.copyWith(isTimeOff: false);
      _localStorageService.setTimerTimeOffPerDay = false;
    }

    if (state.isActive) {
      await _backgroundService.setupBackgroundTask(intervalValue: state.preciseInterval);
    }
  }
}
