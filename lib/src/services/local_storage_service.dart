import 'package:shared_preferences/shared_preferences.dart';
import 'package:norbu_timer/src/features/timer/util/timer_strings_util.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class LocalStorageService {
  final SharedPreferences _preferences;

  LocalStorageService({@required SharedPreferences preferences})
      : assert(preferences != null),
        _preferences = preferences {
    isActivePre = _preferences.getBool(TimerStringsUtil.isActiveKey);
    listMessagesPre = _preferences.getStringList(TimerStringsUtil.messagesKey);
    listCheckMessagesPre = getCheckListMessages();
    sliderValuePre = _preferences.getDouble(TimerStringsUtil.sliderValueKey);
    intervalPre = _preferences.getInt(TimerStringsUtil.intervalValueKey);
    soundSourcePre = _preferences.getInt(TimerStringsUtil.soundSourceKey);
    intervalSourcePre = _preferences.getInt(TimerStringsUtil.intervalSourceKey);
    isTimeOffPre = _preferences.getBool(TimerStringsUtil.isTimeOffKey);
    timeFrom = getTimeOffFrom();
    timeUntil = getTimeOffUntil();
    stateBackFetch = _preferences.getBool(TimerStringsUtil.stateBackFetch);
    if (listMessagesPre == null) listMessagesPre = TimerStringsUtil.listMessages;
    if (intervalSourcePre == null) intervalSourcePre = 0;
    if (soundSourcePre == null) soundSourcePre = 0;
    if (isActivePre == null) isActivePre = false;
    if (stateBackFetch == null) stateBackFetch = false;
    if (isTimeOffPre == null) isTimeOffPre = true;
    if (sliderValuePre == null) sliderValuePre = 8.0;
    if (intervalPre == null) intervalPre = TimerStringsUtil.timeIntervals[sliderValuePre.toInt()];
  }

  bool isActivePre;
  List<String> listMessagesPre;
  List<String> listCheckMessagesPre;
  double sliderValuePre;
  int intervalPre;
  int soundSourcePre;
  int intervalSourcePre;
  bool isTimeOffPre;
  TimeOfDay timeFrom;
  TimeOfDay timeUntil;
  bool stateBackFetch;

  bool get isActivePref => _preferences.getBool(TimerStringsUtil.isActiveKey) ?? false;
  List<String> get listMessagesPref =>
      _preferences.getStringList(TimerStringsUtil.messagesKey) ?? TimerStringsUtil.listMessages;
  List<String> get listCheckMessagesPref => getCheckListMessages();
  int get intervalPref =>
      _preferences.getInt(TimerStringsUtil.intervalValueKey) ?? TimerStringsUtil.timeIntervals[sliderValuePre.toInt()];
  int get soundSourcePref => _preferences.getInt(TimerStringsUtil.soundSourceKey) ?? 0;
  int get intervalSourcePref => _preferences.getInt(TimerStringsUtil.intervalSourceKey) ?? 0;
  bool get isTimeOffPref => _preferences.getBool(TimerStringsUtil.isTimeOffKey) ?? true;

  TimeOfDay get timeFromPref => getTimeOffFrom();
  TimeOfDay get timeUntilPref => getTimeOffUntil();

  bool get stateBackFetchPref => _preferences.getBool(TimerStringsUtil.stateBackFetch) ?? false;

  Future<void> setActive(bool isActive) async {
    await _preferences.setBool(TimerStringsUtil.isActiveKey, isActive);
  }

  Future<void> setInterval(int interval) async {
    await _preferences.setInt(TimerStringsUtil.intervalValueKey, interval);
  }

  Future<void> setSliderVolume(double volume) async {
    await _preferences.setDouble(TimerStringsUtil.sliderValueKey, volume);
  }

  Future<void> setMessages(List<String> mes) async {
    await _preferences.setStringList(TimerStringsUtil.messagesKey, mes);
  }

  Future<void> setSoundSource(int value) async {
    await _preferences.setInt(TimerStringsUtil.soundSourceKey, value);
  }

  Future<void> setIntervalSource(int value) async {
    await _preferences.setInt(TimerStringsUtil.intervalSourceKey, value);
  }

  Future<void> setTimeOffPerDay(bool isTimeOff) async {
    await _preferences.setBool(TimerStringsUtil.isTimeOffKey, isTimeOff);
  }

  //
  Future<void> setTimeOffFrom(TimeOfDay time) async {
    await _preferences.setInt(TimerStringsUtil.timeFromKeyHour, time.hour);
    await _preferences.setInt(TimerStringsUtil.timeFromKeyMinute, time.minute);
  }

  Future<void> setTimeOffUntil(TimeOfDay time) async {
    await _preferences.setInt(TimerStringsUtil.timeUntilKeyHour, time.hour);
    await _preferences.setInt(TimerStringsUtil.timeUntilKeyMinute, time.minute);
  }

  TimeOfDay getTimeOffFrom() {
    int hour = _preferences.getInt(TimerStringsUtil.timeFromKeyHour);
    int minute = _preferences.getInt(TimerStringsUtil.timeFromKeyMinute);
    if (hour == null) hour = 22;
    if (minute == null) minute = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  TimeOfDay getTimeOffUntil() {
    int hour = _preferences.getInt(TimerStringsUtil.timeUntilKeyHour);
    int minute = _preferences.getInt(TimerStringsUtil.timeUntilKeyMinute);
    if (hour == null) hour = 8;
    if (minute == null) minute = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  List<String> getCheckListMessages() {
    List<String> listPre = _preferences.getStringList(TimerStringsUtil.checkMessagesKey);
    List<String> list;
    if (listPre == null) {
      listPre = ["0", "1", "2"];
    } else {
      //list = listPre.map((item) => int.parse(item))?.toList();
    }

    return listPre;
  }

  Future<void> setCheckMessages(List<String> list) async {
    await _preferences.setStringList(TimerStringsUtil.checkMessagesKey, list);
  }

  //
  Future<void> setStateBackFetch(bool init) async {
    await _preferences.setBool(TimerStringsUtil.stateBackFetch, init);
  }
}
