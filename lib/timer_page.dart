import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_awareness/bloc_notification/notification_bloc.dart';
import 'package:timer_awareness/core/constants.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class TimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Timer awareness'),
          actions: [],
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Column(children: <Widget>[
                    _AcceptSwitchButton(),
                    SizedBox(height: 30),
                    _IntervalTimeRadioButtons(),
                    SizedBox(height: 30),
                    _SoundSourceRadioButtons(),
                    SizedBox(height: 30),
                    _VibrationLevelRadioButtons(),
                    SizedBox(height: 30),
                    _TurnOffCheckboxes(),
                    SizedBox(height: 30),
                    _DaysOffToggleButtons(),
                  ]),
                ))));
  }
  /*
  void requestUserPermission(bool isAllowed) async {
      showDialog(
          context: context,
          builder: (_) =>
              NetworkGiffyDialog(
                buttonOkText: Text('Allow', style: TextStyle(color: Colors.white)),
                buttonCancelText: Text('Later', style: TextStyle(color: Colors.white)),
                buttonCancelColor: Colors.grey,
                buttonOkColor: Colors.deepPurple,
                buttonRadius: 0.0,
                image: Image.asset("assets/images/animated-bell.gif", fit: BoxFit.cover),
                title: Text('Get Notified!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600)
                ),
                description: Text('Allow Awesome Notifications to send you beautiful notifications!',
                  textAlign: TextAlign.center,
                ),
                entryAnimation: EntryAnimation.DEFAULT,
                onCancelButtonPressed: () async {
                  Navigator.of(context).pop();
                  notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                  setState(() {
                    notificationsAllowed = notificationsAllowed;
                  });
                },
                onOkButtonPressed: () async {
                  Navigator.of(context).pop();
                  await AwesomeNotifications().requestPermissionToSendNotifications();
                  notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                  setState(() {
                    notificationsAllowed = notificationsAllowed;
                  });
                },
              )
      );
  }
  */
}

class _AcceptSwitchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationService, NotificationState>(
        buildWhen: (previous, current) => previous.isActive != current.isActive,
        builder: (context, state) {
          return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text('Accept')),
                Center(
                  child: Switch(
                    value: state.isActive,
                    onChanged: (value) =>
                        BlocProvider.of<NotificationService>(context)
                            .add(ToggleNotificationService()),
                    activeTrackColor: Colors.grey,
                    activeColor: Colors.amber,
                  ),
                )
              ]));
        });
  }
}

class _IntervalTimeRadioButtons extends StatelessWidget {
  bool _numberInputIsValid;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationService, NotificationState>(
        buildWhen: (previous, current) =>
            previous.intervalSource != current.intervalSource ||
            previous.preciseInterval != current.preciseInterval ||
            previous.randomIntervalMin != current.randomIntervalMin ||
            previous.randomIntervalMax != current.randomIntervalMax,
        builder: (context, state) {
          return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Center(
                        child: Text('Interval time in minute(repeat every)'))),
                Center(
                  child: Row(
                    key: PageStorageKey('Interval'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int index = 0; index < 2; ++index)
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            key: PageStorageKey('Interval' + index.toString()),
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue: state.intervalSource,
                                onChanged: (value) => BlocProvider.of<
                                        NotificationService>(context)
                                    .add(ToggleIntervalSource(value: value)),
                              ),
                              index == 0
                                  ? Container(
                                      width: 60,
                                      height: 40,
                                      child: Flexible(
                                          child: TextField(
                                        controller: TextEditingController()
                                          ..text =
                                              state.preciseInterval.toString(),
                                        keyboardType: TextInputType.number,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                        ),
                                        onChanged: (String val) {
                                          final v = int.tryParse(val);
                                          debugPrint('parsed value = $v');
                                          if (v == null) {
                                            _numberInputIsValid = false;
                                          } else {
                                            _numberInputIsValid = true;
                                            BlocProvider.of<
                                                        NotificationService>(
                                                    context)
                                                .add(ChangedPreciseInterval(
                                                    interval: v));
                                          }
                                        },
                                      )))
                                  : Row(
                                      key: PageStorageKey('Interval11'),
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Container(
                                              width: 60,
                                              height: 40,
                                              child: Flexible(
                                                  child: TextField(
                                                controller:
                                                    TextEditingController()
                                                      ..text = state
                                                          .randomIntervalMin
                                                          .toString(),
                                                keyboardType:
                                                    TextInputType.number,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                  ),
                                                ),
                                                onChanged: (String val) {
                                                  final v = int.tryParse(val);
                                                  debugPrint(
                                                      'parsed value = $v');
                                                  if (v == null) {
                                                    _numberInputIsValid = false;
                                                  } else {
                                                    _numberInputIsValid = true;
                                                    BlocProvider.of<
                                                                NotificationService>(
                                                            context)
                                                        .add(
                                                            ChangedRandomMinInterval(
                                                                intervalMin:
                                                                    v));
                                                  }
                                                },
                                              ))),
                                          Text(' - '),
                                          Container(
                                              width: 60,
                                              height: 40,
                                              child: Flexible(
                                                  child: TextField(
                                                controller:
                                                    TextEditingController()
                                                      ..text = state
                                                          .randomIntervalMax
                                                          .toString(),
                                                keyboardType:
                                                    TextInputType.number,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                  ),
                                                ),
                                                onChanged: (String val) {
                                                  final v = int.tryParse(val);
                                                  debugPrint(
                                                      'parsed value = $v');
                                                  if (v == null) {
                                                    _numberInputIsValid = false;
                                                  } else {
                                                    _numberInputIsValid = true;
                                                    BlocProvider.of<
                                                                NotificationService>(
                                                            context)
                                                        .add(
                                                            ChangedRandomMaxInterval(
                                                                intervalMax:
                                                                    v));
                                                  }
                                                },
                                              ))),
                                          SizedBox(
                                            width: 30,
                                          ),
                                        ]),
                              Text(Constants.intervalMode[index].toString())
                            ]),
                    ],
                  ),
                ),
              ]));
        });
  }
}

class _SoundSourceRadioButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationService, NotificationState>(
        buildWhen: (previous, current) =>
            previous.soundSource != current.soundSource,
        builder: (context, state) {
          return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                Center(child: Text('Sound')),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int index = 0; index < 3; ++index)
                        Column(children: [
                          Radio<int>(
                            value: index,
                            groupValue: state.soundSource,
                            onChanged: (value) =>
                                BlocProvider.of<NotificationService>(context)
                                    .add(ToggleSoundSource(value: value)),
                          ),
                          Text(Constants.soundMode[index].toString())
                        ]),
                    ],
                  ),
                ),
              ]));
        });
  }
}

class _VibrationLevelRadioButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationService, NotificationState>(
        buildWhen: (previous, current) =>
            previous.vibrationLevel != current.vibrationLevel,
        builder: (context, state) {
          return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                Center(child: Text('Vibration')),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int index = 0; index < 4; ++index)
                        Column(children: [
                          Radio<int>(
                            value: index,
                            groupValue: state.vibrationLevel,
                            onChanged: (value) =>
                                BlocProvider.of<NotificationService>(context)
                                    .add(ToggleVibrationLevel(value: value)),
                          ),
                          Text(Constants.vibrationMode[index].toString())
                        ]),
                    ],
                  ),
                ),
              ]));
        });
  }
}

class _TurnOffCheckboxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationService, NotificationState>(
        buildWhen: (previous, current) =>
            previous.isFlightMode != current.isFlightMode ||
            previous.isCallingMode != current.isCallingMode ||
            previous.isSilentMode != current.isSilentMode ||
            previous.isMusicPlaying != current.isMusicPlaying ||
            previous.isTimeOff != current.isTimeOff,
        builder: (context, state) {
          return Center(
            child: Column(
              children: [
                Center(child: Text('Turn off sound when')),
                CheckboxListTile(
                  title: Text('Flight mode'),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: state.isFlightMode,
                  onChanged: (value) =>
                      BlocProvider.of<NotificationService>(context)
                          .add(ToggleOffWhenFlightMode()),
                ),
                CheckboxListTile(
                  title: Text('Calling'),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: state.isCallingMode,
                  onChanged: (value) =>
                      BlocProvider.of<NotificationService>(context)
                          .add(ToggleOffWhenCallingMode()),
                ),
                CheckboxListTile(
                  title: Text('Silent mode'),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: state.isSilentMode,
                  onChanged: (value) =>
                      BlocProvider.of<NotificationService>(context)
                          .add(ToggleOffWhenSilentMode()),
                ),
                CheckboxListTile(
                  title: Text('Playing music'),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: state.isMusicPlaying,
                  onChanged: (value) =>
                      BlocProvider.of<NotificationService>(context)
                          .add(ToggleOffWhenMusicPlaying()),
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        value: state.isTimeOff,
                        onChanged: (value) =>
                            BlocProvider.of<NotificationService>(context)
                                .add(ToggleOffTimePerDay()),
                      ),
                      Text('Break time  '),
                      Expanded(
                          child: DateTimeField(
                        format: DateFormat("hh:mm"),
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          //suffixIcon: Icon(Icons.event_note),
                          labelText: 'From',
                        ),
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.convert(time);
                        },
                        onSaved: (newValue) =>
                            BlocProvider.of<NotificationService>(context)
                                .add(ChangedTimeOffFrom(timeFrom: newValue)),
                      )),
                      Text('-'),
                      Expanded(
                          child: DateTimeField(
                        format: DateFormat("hh:mm"),
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          //suffixIcon: Icon(Icons.event_note),
                          labelText: 'Until',
                        ),
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.convert(time);
                        },
                        onSaved: (newValue) =>
                            BlocProvider.of<NotificationService>(context)
                                .add(ChangedTimeOffUntil(timeUntil: newValue)),
                      )),
                    ]),
              ],
            ),
          );
        });
  }
}

class _DaysOffToggleButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationService, NotificationState>(
        buildWhen: (previous, current) => previous.dayssh != current.dayssh,
        builder: (context, state) {
          return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                Center(child: Text('Days when active')),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ToggleButtons(
                    children: [
                      for (int index = 0; index < 7; ++index)
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          Text(Constants.dayName[index]),
                          state.daysSelected[index]
                              ? Icon(Icons.bookmark)
                              : Icon(Icons.bookmark_border_outlined)
                        ]),
                    ],
                    onPressed: (index) =>
                        BlocProvider.of<NotificationService>(context)
                            .add(ToggleOffDaysPerWeek(index: index)),
                    isSelected: state.daysSelected,
                  ),
                ),
              ]));
        });
  }
}
