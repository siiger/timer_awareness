import 'package:timer_awareness/core/math_util.dart';
import 'package:flutter/material.dart';

class DateTimeUtil {
  DateTimeUtil._();

  static List<DateTime> calculateTimeList({
    int intervalSource,
    int intervalValue,
    TimeOfDay timeFrom,
    TimeOfDay timeUntil,
    bool isTimeOnActivated,
  }) {
    int lengthList = 300;
    List<int> listIntervals;
    List<DateTime> listDate = [];

    if (intervalSource == 0) {
      listIntervals = new List<int>.generate(lengthList, (i) => intervalValue);
    } else if (intervalSource == 1) {
      int randomMin = intervalValue - (intervalValue / 2).round();
      int randomMax = intervalValue + (intervalValue / 2).round();
      listIntervals = new List<int>.generate(
          lengthList, (i) => MathUtil.random(randomMin, randomMax));
    }

    // дата первого уведомления
    final DateTime now = DateTime.now();
    DateTime notificationDateTimeFrom =
        DateTime(now.year, now.month, now.day, timeFrom.hour, timeFrom.minute);
    DateTime notificationDateTimeUntil = DateTime(
        now.year, now.month, now.day, timeUntil.hour, timeUntil.minute);
    if (notificationDateTimeUntil.isBefore(notificationDateTimeFrom)) {
      notificationDateTimeUntil =
          notificationDateTimeUntil.add(const Duration(days: 1));
    }

    DateTime notificationDateTime = now;

    for (int i = 0; i < lengthList; i++) {
      notificationDateTime =
          notificationDateTime.add(Duration(minutes: listIntervals[i]));
      if (isTimeOnActivated) {
        if (notificationDateTime.isAfter(notificationDateTimeFrom) &&
            notificationDateTime.isBefore(notificationDateTimeUntil)) {
          notificationDateTimeFrom =
              notificationDateTimeFrom.add(const Duration(days: 1));
          notificationDateTime = notificationDateTimeUntil;
          listDate.add(notificationDateTime.toUtc());
          notificationDateTimeUntil =
              notificationDateTimeUntil.add(const Duration(days: 1));
        } else if (!(notificationDateTime.isAfter(notificationDateTimeFrom) &&
            notificationDateTime.isBefore(notificationDateTimeUntil))) {
          listDate.add(notificationDateTime.toUtc());
        }
      } else {
        listDate.add(notificationDateTime.toUtc());
      }
    }

    return listDate;
  }
}
