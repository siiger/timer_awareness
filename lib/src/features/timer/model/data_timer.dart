import 'dart:convert';

class DataTimer {
  final int intervalSource;
  final int intervalValue;
  final String soundSourcePath;
  final bool isTimeOnActivated;
  final List<String> messages;
  final List<int> timeFrom;
  final List<int> timeUntil;
  DataTimer({
    this.intervalSource,
    this.intervalValue,
    this.soundSourcePath,
    this.isTimeOnActivated,
    this.messages,
    this.timeFrom,
    this.timeUntil,
  });

  Map<String, dynamic> toMap() {
    return {
      'intervalSource': intervalSource,
      'intervalValue': intervalValue,
      'soundSourcePath': soundSourcePath,
      'isTimeOnActivated': isTimeOnActivated,
      'messages': messages,
      'timeFrom': timeFrom,
      'timeUntil': timeUntil,
    };
  }

  factory DataTimer.fromMap(Map<String, dynamic> map) {
    List<String> messages =
        (map['messages'] as List)?.map((item) => item as String)?.toList();
    List<int> listFrom =
        (map['timeFrom'] as List)?.map((item) => item as int)?.toList();
    List<int> listUntil =
        (map['timeUntil'] as List)?.map((item) => item as int)?.toList();
    return DataTimer(
      intervalSource: map['intervalSource'],
      intervalValue: map['intervalValue'],
      soundSourcePath: map['soundSourcePath'].toString(),
      isTimeOnActivated: map['isTimeOnActivated'],
      messages: messages,
      timeFrom: listFrom,
      timeUntil: listUntil,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataTimer.fromJson(String source) =>
      DataTimer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DataTimer(intervalSource: $intervalSource, intervalValue: $intervalValue, soundSourcePath: $soundSourcePath, isTimeOnActivated: $isTimeOnActivated, messages: $messages, listTimeFrom: $timeFrom, listTimeUntil: $timeUntil)';
  }
}
