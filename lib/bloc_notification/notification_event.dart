part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class ToggleNotificationService extends NotificationEvent {}

class ToggleOffWhenMusicPlaying extends NotificationEvent {}

class ToggleOffWhenSilentMode extends NotificationEvent {}

class ToggleOffWhenFlightMode extends NotificationEvent {}

class ToggleOffWhenCallingMode extends NotificationEvent {}

class ToggleOffTimePerDay extends NotificationEvent {}

class ChangedPreciseInterval extends NotificationEvent {
  final int interval;

  ChangedPreciseInterval({this.interval});
  @override
  List<Object> get props => [interval];
}

class ChangedRandomMinInterval extends NotificationEvent {
  final int intervalMin;

  ChangedRandomMinInterval({this.intervalMin});
  @override
  List<Object> get props => [intervalMin];
}

class ChangedRandomMaxInterval extends NotificationEvent {
  final int intervalMax;

  ChangedRandomMaxInterval({this.intervalMax});
  @override
  List<Object> get props => [intervalMax];
}

class ToggleSoundSource extends NotificationEvent {
  final int value;

  ToggleSoundSource({this.value});
  @override
  List<Object> get props => [value];
}

class ToggleIntervalSource extends NotificationEvent {
  final int value;

  ToggleIntervalSource({this.value});
  @override
  List<Object> get props => [value];
}

class ToggleVibrationLevel extends NotificationEvent {
  final int value;

  ToggleVibrationLevel({this.value});
  @override
  List<Object> get props => [value];
}

class ChangedTimeOffFrom extends NotificationEvent {
  final DateTime timeFrom;

  ChangedTimeOffFrom({this.timeFrom});
  @override
  List<Object> get props => [timeFrom];
}

class ChangedTimeOffUntil extends NotificationEvent {
  final DateTime timeUntil;

  ChangedTimeOffUntil({this.timeUntil});
  @override
  List<Object> get props => [timeUntil];
}

class ToggleOffDaysPerWeek extends NotificationEvent {
  final int index;

  ToggleOffDaysPerWeek({this.index});
  @override
  List<Object> get props => [index];
}
