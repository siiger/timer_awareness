part of 'timer_settings_bloc.dart';

abstract class TimerSettingsEvent extends Equatable {
  const TimerSettingsEvent();

  @override
  List<Object> get props => [];
}

class ToggleNotificationService extends TimerSettingsEvent {}

class ToggleOffWhenMusicPlaying extends TimerSettingsEvent {}

class ToggleOffWhenSilentMode extends TimerSettingsEvent {}

class ToggleOffWhenFlightMode extends TimerSettingsEvent {}

class ToggleOffWhenCallingMode extends TimerSettingsEvent {}

class ToggleOffTimePerDay extends TimerSettingsEvent {}

class InitSettings extends TimerSettingsEvent {}

class ChangedPreciseInterval extends TimerSettingsEvent {
  final int interval;

  ChangedPreciseInterval({this.interval});
  @override
  List<Object> get props => [interval];
}

class ChangedSliderVolume extends TimerSettingsEvent {
  final double volume;

  ChangedSliderVolume({this.volume});
  @override
  List<Object> get props => [volume];
}

class ToggleSoundSource extends TimerSettingsEvent {
  final int value;

  ToggleSoundSource({this.value});
  @override
  List<Object> get props => [value];
}

class ToggleIntervalSource extends TimerSettingsEvent {
  final int value;

  ToggleIntervalSource({this.value});
  @override
  List<Object> get props => [value];
}

class ChangedTimeOffFrom extends TimerSettingsEvent {
  final TimeOfDay timeFrom;

  ChangedTimeOffFrom({this.timeFrom});
  @override
  List<Object> get props => [timeFrom];
}

class ChangedTimeOffUntil extends TimerSettingsEvent {
  final TimeOfDay timeUntil;

  ChangedTimeOffUntil({this.timeUntil});
  @override
  List<Object> get props => [timeUntil];
}

class ChangedMessages extends TimerSettingsEvent {
  final String message;
  final int index;

  ChangedMessages({this.message, this.index});
  @override
  List<Object> get props => [message, index];
}

class CheckMessage extends TimerSettingsEvent {
  final int index;

  CheckMessage({this.index});
  @override
  List<Object> get props => [index];
}
