import 'package:norbu_timer/core/math_util.dart';
import 'package:flutter/material.dart';

class DateTimeUtil {
  DateTimeUtil._();

  static DateTime nextTimeWithConditions(
      {DateTime currentTime,
      int intervalValue,
      TimeOfDay timeFrom,
      TimeOfDay timeUntil}) {
    DateTime result;
    result = currentTime.add(Duration(minutes: intervalValue));
    if (timeFrom.hour > timeUntil.hour) {
      if (result.isAfter(DateTime(result.year, result.month, result.day,
              timeUntil.hour, timeUntil.minute)) &&
          result.isBefore(DateTime(result.year, result.month, result.day,
              timeFrom.hour, timeFrom.minute))) {
      } else if (result.isBefore(DateTime(result.year, result.month, result.day,
          timeUntil.hour, timeUntil.minute))) {
        result = DateTime(result.year, result.month, result.day, timeUntil.hour,
            timeUntil.minute);
      } else if (result.isAfter(DateTime(result.year, result.month, result.day,
          timeFrom.hour, timeFrom.minute))) {
        result = DateTime(result.year, result.month, result.day + 1,
            timeUntil.hour, timeUntil.minute);
      }
    } else if (timeFrom.hour < timeUntil.hour) {
      if (result.isAfter(DateTime(result.year, result.month, result.day,
              timeUntil.hour, timeUntil.minute)) ||
          result.isBefore(DateTime(result.year, result.month, result.day,
              timeFrom.hour, timeFrom.minute))) {
      } else if (result.isAfter(DateTime(result.year, result.month, result.day,
              timeFrom.hour, timeFrom.minute)) &&
          result.isBefore(DateTime(result.year, result.month, result.day,
              timeUntil.hour, timeUntil.minute))) {
        result = DateTime(result.year, result.month, result.day, timeUntil.hour,
            timeUntil.minute);
      }
    }
    return result;
  }

  static DateTime nextTime({
    DateTime currentTime,
    int intervalValue,
    TimeOfDay timeFrom,
    TimeOfDay timeUntil,
    int intervalSource,
    bool isTimeOnActivated,
  }) {
    DateTime result;
    int intervalRes;

    if (intervalSource == 0) {
      intervalRes = intervalValue;
    } else if (intervalSource == 1) {
      int randomMin = intervalValue - (intervalValue / 2).round();
      //int randomMax = intervalValue + (intervalValue / 2).round();
      intervalRes = MathUtil.random(randomMin, intervalValue + 1);
    }

    if (isTimeOnActivated) {
      result = nextTimeWithConditions(
          currentTime: currentTime,
          intervalValue: intervalRes,
          timeFrom: timeFrom,
          timeUntil: timeUntil);
    } else {
      result = currentTime.add(Duration(minutes: intervalRes));
    }

    return result;
  }

  static int intervalDelayInSeconds({
    int intervalValue,
    List<int> timeFrom,
    List<int> timeUntil,
    int intervalSource,
    bool isTimeOnActivated,
  }) {
    DateTime currentTime = DateTime.now();

    DateTime nexTime = nextTime(
        currentTime: currentTime,
        intervalValue: intervalValue,
        timeFrom: TimeOfDay(hour: timeFrom[0], minute: timeFrom[1]),
        timeUntil: TimeOfDay(hour: timeUntil[0], minute: timeUntil[1]),
        intervalSource: intervalSource,
        isTimeOnActivated: isTimeOnActivated);

    return nexTime.difference(currentTime).inSeconds;
  }

  static int intervalDelayInMinutes({
    int intervalValue,
    TimeOfDay timeFrom,
    TimeOfDay timeUntil,
    int intervalSource,
    bool isTimeOnActivated,
  }) {
    DateTime currentTime = DateTime.now();

    DateTime nexTime = nextTime(
        currentTime: currentTime,
        intervalValue: intervalValue,
        timeFrom: timeFrom,
        timeUntil: timeUntil,
        intervalSource: intervalSource,
        isTimeOnActivated: isTimeOnActivated);

    return nexTime.difference(currentTime).inMinutes;
  }
}
