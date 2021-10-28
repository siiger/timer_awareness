import 'package:shared_preferences/shared_preferences.dart';
import 'package:norbu_timer/src/features/timer/util/timer_strings_util.dart';
import 'package:flutter/material.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  set setTimerActive(bool isActive) => _saveToDisk('isTimerActived', isActive);
  bool get isTimerActived => _getFromDisk('isTimerActived') ?? false;
  // Период появления сообщения
  set setTimerInterval(int interval) => _saveToDisk('intervalValue', interval);
  int get timerInterval => _getFromDisk('intervalValue') ?? TimerStringsUtil.timeIntervals[5];
  // слайдер для задания периода
  set setTimerSliderVolume(double volume) => _saveToDisk('sliderValue', volume);
  double get timerSliderValue => _getFromDisk('sliderValue') ?? 5.0;
  // Список допустимых сообщений
  set setTimerMessages(List<String> mes) => _saveToDisk('timerMessages', mes);
  List<String> get timerListMessages => _preferences.getStringList('timerMessages') ?? TimerStringsUtil().listMessages;
  // порядковый номер источника звука для сообщения в списке путей
  set setTimerSoundSource(int value) => _saveToDisk('soundSource', value);
  int get timerSoundSource => _getFromDisk('soundSource') ?? 0;
  // 0-точный период, 1-рандомный
  set setTimerIntervalSource(int value) => _saveToDisk('intervalSource', value);
  int get timerIntervalSource => _getFromDisk('intervalSource') ?? 0;
  // вкл/выкл работы таймера в время "кода не беспокоить"
  set setTimerTimeOffPerDay(bool isTimeOff) => _saveToDisk('isTimeOff', isTimeOff);
  bool get isTimerTimeOff => _getFromDisk('isTimeOff') ?? true;
  // какие сообщения будут в допустимом списке для уведомления
  set setTimerCheckMessages(List<String> list) => _saveToDisk('checkMessages', list);
  List<String> get timerListCheckMessages => _preferences.getStringList('checkMessages') ?? ["1", "2"];

  set setNotificationLabelButton(String label) => _saveToDisk('notificationLabelButton', label);
  String get notificationLabelButton => _preferences.getString('notificationLabelButton');

  set setNotificationBody(String body) => _saveToDisk('notificationBody', body);
  String get notificationBody => _preferences.getString('notificationBody');

  TimeOfDay get timerTimeFrom => _getTimeOffFrom();
  TimeOfDay get timerTimeUntil => _getTimeOffUntil();

  Future<void> setTimerTimeOffFrom(TimeOfDay time) async {
    await _preferences.setInt('timeFromKeyHour', time.hour);
    await _preferences.setInt('timeFromKeyMinute', time.minute);
  }

  Future<void> setTimerTimeOffUntil(TimeOfDay time) async {
    await _preferences.setInt('timeUntilKeyHour', time.hour);
    await _preferences.setInt('timeUntilKeyMinute', time.minute);
  }

  TimeOfDay _getTimeOffFrom() {
    int hour = _preferences.getInt('timeFromKeyHour');
    int minute = _preferences.getInt('timeFromKeyMinute');
    if (hour == null) hour = 22;
    if (minute == null) minute = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  TimeOfDay _getTimeOffUntil() {
    int hour = _preferences.getInt('timeUntilKeyHour');
    int minute = _preferences.getInt('timeUntilKeyMinute');
    if (hour == null) hour = 8;
    if (minute == null) minute = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  T _getFromDisk<T>(String key) {
    return _preferences.get(key) as T;
  }

  void _saveToDisk<T>(String key, T content) {
    if (content == null) {
      _preferences.remove(key);
    }
    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }
}
