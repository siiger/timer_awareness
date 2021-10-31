import 'package:get_it/get_it.dart';
import 'package:norbu_timer/src/services/background_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:norbu_timer/src/services/local_storage_service.dart';
import 'package:background_fetch/background_fetch.dart';

GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  //

  final pref = await LocalStorageService.getInstance();
  sl.registerSingleton<LocalStorageService>(pref);

  //
  final backgroundService = await BackgroundService.getInstance();
  sl.registerSingleton<BackgroundService>(backgroundService);

  //
  final AudioPlayer audioPlayer = AudioPlayer();
  sl.registerSingleton<AudioPlayer>(audioPlayer);
}
