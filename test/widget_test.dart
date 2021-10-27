// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norbu_timer/src/core/utils/date_time_util.dart';
import 'package:norbu_timer/src/core/utils/math_util.dart';

import 'package:norbu_timer/main.dart';

void main() {
  DateTime time = DateTimeUtil.nextTime(
      currentTime: DateTime.now(),
      intervalValue: 10,
      timeFrom: TimeOfDay(hour: 23, minute: 0),
      timeUntil: TimeOfDay(hour: 22, minute: 0));
  print(time);
  int intervalValue = 5;
  int randomMin = intervalValue - (intervalValue / 2).round();
  List<int> listIntervals = new List<int>.generate(10, (i) => MathUtil.random(randomMin, intervalValue));
  print(listIntervals);
  /*testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  */
}
