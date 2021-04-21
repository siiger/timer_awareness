part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final bool isActive;
  final bool isFlightMode;
  final bool isCallingMode;
  final bool isSilentMode;
  final bool isMusicPlaying;
  final bool isTimeOff;
  final DateTime timeFrom;
  final DateTime timeUntil;
  final int intervalSource;
  final int preciseInterval;
  final int randomIntervalMin;
  final int randomIntervalMax;
  final int soundSource;
  final double soundVolume;
  final int vibrationLevel;
  final List<bool> daysSelected;
  final bool dayssh;

  const NotificationState({
    this.isActive,
    this.isFlightMode,
    this.isCallingMode,
    this.isSilentMode,
    this.isMusicPlaying,
    this.isTimeOff,
    this.timeFrom,
    this.timeUntil,
    this.intervalSource,
    this.preciseInterval,
    this.randomIntervalMin,
    this.randomIntervalMax,
    this.soundSource,
    this.soundVolume,
    this.vibrationLevel,
    this.daysSelected,
    this.dayssh,
  });

  @override
  List<Object> get props {
    return [
      isActive,
      isFlightMode,
      isCallingMode,
      isSilentMode,
      isMusicPlaying,
      isTimeOff,
      timeFrom,
      timeUntil,
      intervalSource,
      preciseInterval,
      randomIntervalMin,
      randomIntervalMax,
      soundSource,
      soundVolume,
      vibrationLevel,
      daysSelected,
      dayssh,
    ];
  }

  NotificationState copyWith({
    bool isActive,
    bool isFlightMode,
    bool isCallingMode,
    bool isSilentMode,
    bool isMusicPlaying,
    bool isTimeOff,
    DateTime timeFrom,
    DateTime timeUntil,
    int intervalSource,
    int preciseInterval,
    int randomIntervalMin,
    int randomIntervalMax,
    int soundSource,
    double soundVolume,
    int vibrationLevel,
    List<bool> daysSelected,
    bool dayssh,
  }) {
    return NotificationState(
      isActive: isActive ?? this.isActive,
      isFlightMode: isFlightMode ?? this.isFlightMode,
      isCallingMode: isCallingMode ?? this.isCallingMode,
      isSilentMode: isSilentMode ?? this.isSilentMode,
      isMusicPlaying: isMusicPlaying ?? this.isMusicPlaying,
      isTimeOff: isTimeOff ?? this.isTimeOff,
      timeFrom: timeFrom ?? this.timeFrom,
      timeUntil: timeUntil ?? this.timeUntil,
      intervalSource: intervalSource ?? this.intervalSource,
      preciseInterval: preciseInterval ?? this.preciseInterval,
      randomIntervalMin: randomIntervalMin ?? this.randomIntervalMin,
      randomIntervalMax: randomIntervalMax ?? this.randomIntervalMax,
      soundSource: soundSource ?? this.soundSource,
      soundVolume: soundVolume ?? this.soundVolume,
      vibrationLevel: vibrationLevel ?? this.vibrationLevel,
      daysSelected: daysSelected ?? this.daysSelected,
      dayssh: dayssh ?? this.dayssh,
    );
  }

  @override
  bool get stringify => true;
}
