class Constants {
  static const List<String> soundMode = [
    'Bell Di Mayo   ',
    'Bell   ',
    'Tibetian Bowl     ',
    'System    '
  ];
  static const List<String> intervalMode = ['Precise  ', 'Random'];
  static const List<String> vibrationMode = [
    'Without   ',
    'Low   ',
    'Medium   ',
    'Hight   '
  ];

  static const List<String> dayName = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
  ];

  static const List<int> timeIntervals = [
    1,
    5,
    10,
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

  static const String isActiveKey = 'isActive';
  static const String messagesKey = 'messages';
  static const String sliderValueKey = 'sliderValue';
  static const String intervalValueKey = 'intervalValue';
  static const String soundSourceKey = 'soundSource';
  static const String intervalSourceKey = 'intervalSource';
  static const String isTimeOffKey = 'isTimeOff';
  static const String timeFromKeyHour = 'timeFromHour';
  static const String timeFromKeyMinute = 'timeFromMinute';
  static const String timeUntilKeyHour = 'timeUntilHour';
  static const String timeUntilKeyMinute = 'timeUntilMinute';

  static const List<String> soundSourceArray = [
    'resource://raw/rhy_bre_sound3_hold',
    'resource://raw/rhy_bre_sound1_emp',
    'resource://raw/rhy_bre_sound2_inh'
  ];
}
