import 'package:shared_preferences/shared_preferences.dart';
import 'package:norbu_timer/core/constants.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class SharedPrefUtil {
  final SharedPreferences _preferences;

  SharedPrefUtil({@required SharedPreferences preferences})
      : assert(preferences != null),
        _preferences = preferences {
    isActivePre = _preferences.getBool(Constants.isActiveKey);
    listMessagesPre = _preferences.getStringList(Constants.messagesKey);
    sliderValuePre = _preferences.getDouble(Constants.sliderValueKey);
    intervalPre = _preferences.getInt(Constants.intervalValueKey);
    soundSourcePre = _preferences.getInt(Constants.soundSourceKey);
    intervalSourcePre = _preferences.getInt(Constants.intervalSourceKey);
    isTimeOffPre = _preferences.getBool(Constants.isTimeOffKey);
    timeFrom = getTimeOffFrom();
    timeUntil = getTimeOffUntil();
    if (listMessagesPre == null) listMessagesPre = Constants.listMessages;
    if (intervalSourcePre == null) intervalSourcePre = 0;
    if (soundSourcePre == null) soundSourcePre = 0;
    if (isActivePre == null) isActivePre = false;
    if (isTimeOffPre == null) isTimeOffPre = true;
    if (sliderValuePre == null) sliderValuePre = 8.0;
    if (intervalPre == null)
      intervalPre = Constants.timeIntervals[sliderValuePre.toInt()];
  }

  bool isActivePre;
  List<String> listMessagesPre;
  double sliderValuePre;
  int intervalPre;
  int soundSourcePre;
  int intervalSourcePre;
  bool isTimeOffPre;
  TimeOfDay timeFrom;
  TimeOfDay timeUntil;

  Future<void> setActive(bool isActive) async {
    await _preferences.setBool(Constants.isActiveKey, isActive);
  }

  Future<void> setInterval(int interval) async {
    await _preferences.setInt(Constants.intervalValueKey, interval);
  }

  Future<void> setSliderVolume(double volume) async {
    await _preferences.setDouble(Constants.sliderValueKey, volume);
  }

  Future<void> setMessages(List<String> mes) async {
    await _preferences.setStringList(Constants.messagesKey, mes);
  }

  Future<void> setSoundSource(int value) async {
    await _preferences.setInt(Constants.soundSourceKey, value);
  }

  Future<void> setIntervalSource(int value) async {
    await _preferences.setInt(Constants.intervalSourceKey, value);
  }

  Future<void> setTimeOffPerDay(bool isTimeOff) async {
    await _preferences.setBool(Constants.isTimeOffKey, isTimeOff);
  }

  //
  Future<void> setTimeOffFrom(TimeOfDay time) async {
    await _preferences.setInt(Constants.timeFromKeyHour, time.hour);
    await _preferences.setInt(Constants.timeFromKeyMinute, time.minute);
  }

  Future<void> setTimeOffUntil(TimeOfDay time) async {
    await _preferences.setInt(Constants.timeUntilKeyHour, time.hour);
    await _preferences.setInt(Constants.timeUntilKeyMinute, time.minute);
  }

  TimeOfDay getTimeOffFrom() {
    int hour = _preferences.getInt(Constants.timeFromKeyHour);
    int minute = _preferences.getInt(Constants.timeFromKeyMinute);
    if (hour == null) hour = 22;
    if (minute == null) minute = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  TimeOfDay getTimeOffUntil() {
    int hour = _preferences.getInt(Constants.timeUntilKeyHour);
    int minute = _preferences.getInt(Constants.timeUntilKeyMinute);
    if (hour == null) hour = 8;
    if (minute == null) minute = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }
  //

}
