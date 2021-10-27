import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:norbu_timer/src/features/timer/blocs/bloc_timer_settings/timer_settings_bloc.dart';
import 'package:norbu_timer/src/features/timer/timer_page.dart';
import 'package:norbu_timer/src/config/routes.dart';
import 'package:norbu_timer/service_locator.dart';
import 'package:norbu_timer/src/services/notification_service.dart';
import 'package:norbu_timer/src/common_widgets/notifications_home_page.dart';
import 'package:audioplayers/audioplayers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  static Color mainColor = Color(0xFF9D50DD);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => NotificationTimerSettings(
                notificationService: sl<NotificationService>(), audioPlayer: sl<AudioPlayer>())
              ..add(InitSettings()),
            child: TimerPage()),
      ],
      child: MaterialApp(
        navigatorKey: sl<GlobalKey>(),
        routes: materialRoutes,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(109, 234, 255, 1),
          accentColor: Color.fromRGBO(72, 74, 126, 1),
          brightness: Brightness.dark,
        ),
        title: 'Norbu-Timer',
        home: NotificationHomePage(),
      ),
    );
  }
}
