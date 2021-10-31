import 'dart:async';
import 'dart:collection';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:norbu_timer/src/config/themes.dart';
import 'package:norbu_timer/src/features/timer/blocs/bloc_timer_settings/timer_settings_bloc.dart';
import 'package:norbu_timer/src/features/timer/timer_screen.dart';
import 'package:norbu_timer/src/config/routes.dart';
import 'package:norbu_timer/service_locator.dart';
import 'package:norbu_timer/src/services/background_service.dart';
import 'package:norbu_timer/src/services/local_storage_service.dart';
import 'package:norbu_timer/src/common_widgets/notifications_home_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logging/logging.dart';

ListQueue<String> debugMessages = ListQueue();

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    final debugMessagePrint = '[app: ${record.loggerName}] ${record.message}';
    final debugMessageQueue = '${record.time} ${record.loggerName}: ${record.message}';
    debugPrint(debugMessagePrint);
    debugMessages.add(debugMessageQueue);
    if (debugMessages.length > 200) {
      debugMessages.removeFirst();
    }
  });
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(App());
}

class App extends StatefulWidget {
  static Color mainColor = Color(0xFF9D50DD);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();
  StreamSubscription _onSelectNotificationStreamSubscr;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => TimerSettingsBloc(
                backgroundService: sl<BackgroundService>(),
                localStorageService: sl<LocalStorageService>(),
                audioPlayer: sl<AudioPlayer>())
              ..add(InitSettings()),
            child: TimerScreen()),
      ],
      child: MaterialApp(
        builder: (BuildContext context, Widget child) {
          // Subscribe to the transition events from notification
          _onSelectNotificationStreamSubscr ??=
              sl<BackgroundService>().notificationActionStream.listen(_onReceiveNotification);
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: child,
          );
        },
        navigatorKey: _navigator,
        routes: materialRoutes,
        theme: kShrineTheme,
        title: 'Timer Awareness',
        initialRoute: PAGE_NOTIFICATION_HOME,
      ),
    );
  }

  @override
  void dispose() {
    _onSelectNotificationStreamSubscr?.cancel();
    super.dispose();
  }

  void _onReceiveNotification(ReceivedAction receivedNotification) {
    if (!StringUtils.isNullOrEmpty(receivedNotification.buttonKeyPressed) &&
        receivedNotification.buttonKeyPressed.startsWith('Settings_')) {
      //if press button on settings notification
      _navigator.currentState.pushNamedAndRemoveUntil(
        PAGE_SETTINGS,
        (route) => (route.settings.name != PAGE_SETTINGS) || route.isFirst,
      );
    } else {
      //if tap notifications
      _navigator.currentState.pushNamedAndRemoveUntil(
        PAGE_NOTIFICATION_HOME,
        (route) => (route.settings.name != PAGE_NOTIFICATION_HOME) || route.isFirst,
      );
    }
  }
}
