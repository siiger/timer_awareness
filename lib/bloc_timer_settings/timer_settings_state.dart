part of 'timer_settings_bloc.dart';

class TimerSettingsState extends Equatable {
  final bool isActive;
  final bool isFlightMode;
  final bool isCallingMode;
  final bool isSilentMode;
  final bool isMusicPlaying;
  final bool isTimeOff;
  final TimeOfDay timeFrom;
  final TimeOfDay timeUntil;
  final int intervalSource;
  final int preciseInterval;
  final int soundSource;
  final double currentSliderVolume;
  final List<String> messages;
  final List<String> checkMessages;

  const TimerSettingsState({
    this.isActive = false,
    this.isFlightMode = false,
    this.isCallingMode = false,
    this.isSilentMode = false,
    this.isMusicPlaying = false,
    this.isTimeOff = true,
    this.timeFrom,
    this.timeUntil,
    this.intervalSource = 0,
    this.preciseInterval = 1,
    this.soundSource = 0,
    this.currentSliderVolume = 0.5,
    this.messages,
    this.checkMessages,
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
      soundSource,
      currentSliderVolume,
      messages,
      checkMessages,
    ];
  }

  TimerSettingsState copyWith({
    bool isActive,
    bool isFlightMode,
    bool isCallingMode,
    bool isSilentMode,
    bool isMusicPlaying,
    bool isTimeOff,
    TimeOfDay timeFrom,
    TimeOfDay timeUntil,
    int intervalSource,
    int preciseInterval,
    int soundSource,
    double currentSliderVolume,
    List<String> messages,
    List<String> checkMessages,
  }) {
    return TimerSettingsState(
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
      soundSource: soundSource ?? this.soundSource,
      currentSliderVolume: currentSliderVolume ?? this.currentSliderVolume,
      messages: messages ?? this.messages,
      checkMessages: checkMessages ?? this.checkMessages,
    );
  }

  @override
  bool get stringify => true;
}
