class TimerStringsUtil {
  static const List<String> soundMode = ['Bell Di Mayo   ', 'Bell   ', 'Tibetian Bowl     ', 'System    '];

  List<String> listMessages = ['Thanks yourself.', 'Yes, I\u0027m in the moment!', 'Hurray I am!'];
  static const List<String> intervalMode = ['Precise  ', 'Random'];
  String notificationLabelButton = "Timer settings";
  String notificationBody = "Timer Awareness\n";
  static const List<String> vibrationMode = ['Without   ', 'Low   ', 'Medium   ', 'Hight   '];

  static const List<String> dayName = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  static String showStringTime(int i) {
    String res = '';
    int indexHours = timeIntervals.indexOf(60);
    if (i < indexHours) {
      res = '${timeIntervals[i]} minute';
    } else if (i == indexHours) {
      res = '${timeIntervals[i] / 60} hour';
    } else if (i > indexHours) {
      res = '${timeIntervals[i] / 60} hours';
    }
    return res;
  }

  static const List<String> soundSourceArray = [
    'resource://raw/res_rhy_bre_sound3_hold',
    'resource://raw/res_rhy_bre_sound1_emp',
    'resource://raw/res_rhy_bre_sound2_inh'
  ];

  static const List<int> timeIntervals = [
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    55,
    60,
    90,
    120,
    150,
    180,
    240,
    360,
    480,
    600,
    720,
    840,
    960,
    1080,
    1200,
    1320,
    1440,
  ];
}
