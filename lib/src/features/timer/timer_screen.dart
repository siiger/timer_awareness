import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:norbu_timer/src/features/timer/blocs/bloc_timer_settings/timer_settings_bloc.dart';
import 'package:norbu_timer/src/features/timer/util/timer_strings_util.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:norbu_timer/src/common_widgets/custom_container.dart';
import 'package:easy_debounce/easy_debounce.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Timer Awareness'),
          actions: [],
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Column(children: <Widget>[
                    _AcceptSwitchButton(),
                    SizedBox(height: 30),
                    _MessagesTextField(),
                    SizedBox(height: 50),
                    _IntervalTimeRadioButtons(),
                    SizedBox(height: 50),
                    _SoundSourceRadioButtons(),
                    //SizedBox(height: 30),
                    //_VibrationLevelRadioButtons(),
                    SizedBox(height: 50),
                    _TurnOffCheckboxes(),
                    SizedBox(height: 50),
                    //_DaysOffToggleButtons(),
                  ]),
                ))));
  }
}

class _AcceptSwitchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerSettingsBloc, TimerSettingsState>(
        buildWhen: (previous, current) => previous.isActive != current.isActive,
        builder: (context, state) {
          return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 8), child: Text('Off / On')),
                Center(
                  child: Switch(
                    value: state.isActive,
                    onChanged: (value) => BlocProvider.of<TimerSettingsBloc>(context).add(ToggleNotificationService()),
                    activeTrackColor: Colors.grey,
                    activeColor: Colors.amber,
                  ),
                )
              ]));
        });
  }
}

class _MessagesTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerSettingsBloc, TimerSettingsState>(
        buildWhen: (previous, current) =>
            previous.messages != current.messages || previous.checkMessages != current.checkMessages,
        builder: (context, state) {
          return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 8), child: Center(child: Text('Messages'))),
                for (int index = 0; index < 3; ++index)
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: state.checkMessages.contains(index.toString()),
                          onChanged: (value) =>
                              BlocProvider.of<TimerSettingsBloc>(context).add(CheckMessage(index: index)),
                        ),
                        Container(
                            width: 220,
                            height: 40,
                            child: TextField(
                              key: PageStorageKey('Messages' + index.toString()),
                              controller: TextEditingController()..text = state.messages[index],
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              onChanged: (String val) => EasyDebounce.debounce(
                                  'mess-debouncer',
                                  Duration(milliseconds: 1000),
                                  () => BlocProvider.of<TimerSettingsBloc>(context)
                                      .add(ChangedMessages(message: val, index: index))),
                            ))
                      ]),
              ]));
        });
  }
}

class _IntervalTimeRadioButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerSettingsBloc, TimerSettingsState>(
        buildWhen: (previous, current) =>
            previous.intervalSource != current.intervalSource ||
            previous.preciseInterval != current.preciseInterval ||
            previous.currentSliderVolume != current.currentSliderVolume,
        builder: (context, state) {
          return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8), child: Center(child: Text('Interval (repeat every)'))),
                Center(
                  child: Row(
                    key: PageStorageKey('Interval'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int index = 0; index < 2; ++index)
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            key: PageStorageKey('Interval' + index.toString()),
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Text(TimerStringsUtil.intervalMode[index].toString()),
                              Radio<int>(
                                value: index,
                                groupValue: state.intervalSource,
                                onChanged: (value) =>
                                    BlocProvider.of<TimerSettingsBloc>(context).add(ToggleIntervalSource(value: value)),
                              ),
                            ]),
                    ],
                  ),
                ),
                Row(mainAxisSize: MainAxisSize.max, children: [
                  Container(
                    height: 30,
                    width: 80,
                    //color: Colors.purple,
                    alignment: Alignment.center,
                    //margin: EdgeInsets.all(1),
                    //padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.grey, width: 1),
                      //borderRadius:
                    ),
                    child: Text(
                      '${TimerStringsUtil.showStringTime(state.currentSliderVolume.round())}',
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Expanded(
                      child: Slider(
                    value: state.currentSliderVolume,
                    min: 0,
                    max: TimerStringsUtil.timeIntervals.length.toDouble() - 1,
                    divisions: TimerStringsUtil.timeIntervals.length - 1,
                    label: TimerStringsUtil.showStringTime(state.currentSliderVolume.round()),
                    onChanged: (double value) =>
                        BlocProvider.of<TimerSettingsBloc>(context).add(ChangedSliderVolume(volume: value)),
                    onChangeEnd: (double value) => EasyDebounce.debounce(
                        'slider-debouncer',
                        Duration(milliseconds: 3000),
                        () => BlocProvider.of<TimerSettingsBloc>(context)
                            .add(ChangedPreciseInterval(interval: value.toInt()))),
                  )),
                ]),
              ]));
        });
  }
}

class _SoundSourceRadioButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerSettingsBloc, TimerSettingsState>(
        buildWhen: (previous, current) => previous.soundSource != current.soundSource,
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
                      for (int index = 0; index < TimerStringsUtil.soundMode.length; ++index)
                        Column(children: [
                          Radio<int>(
                            value: index,
                            groupValue: state.soundSource,
                            onChanged: (value) =>
                                BlocProvider.of<TimerSettingsBloc>(context).add(ToggleSoundSource(value: value)),
                          ),
                          Text(TimerStringsUtil.soundMode[index].toString())
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
    return BlocBuilder<TimerSettingsBloc, TimerSettingsState>(
        buildWhen: (previous, current) => previous.isTimeOff != current.isTimeOff,
        builder: (context, state) {
          final DateTime now = DateTime.now();
          return Center(
            child: Column(
              children: [
                Center(
                    child:
                        const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10), child: Text('Don\u0027t show when'))),
                /*CheckboxListTile(
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
                */
                Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end, children: [
                  Checkbox(
                    value: state.isTimeOff,
                    onChanged: (value) => BlocProvider.of<TimerSettingsBloc>(context).add(ToggleOffTimePerDay()),
                  ),
                  Expanded(
                      child: DateTimeField(
                    format: DateFormat("HH:mm"),
                    initialValue: DateTime(now.year, now.month, now.day, state.timeFrom.hour, state.timeFrom.minute),
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
                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.convert(time);
                    },
                    onChanged: (newValue) => BlocProvider.of<TimerSettingsBloc>(context)
                        .add(ChangedTimeOffFrom(timeFrom: TimeOfDay(hour: newValue.hour, minute: newValue.minute))),
                  )),
                  Text('  -  '),
                  Expanded(
                      child: DateTimeField(
                    format: DateFormat("HH:mm"),
                    initialValue: DateTime(now.year, now.month, now.day, state.timeUntil.hour, state.timeUntil.minute),
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
                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.convert(time);
                    },
                    onChanged: (newValue) => BlocProvider.of<TimerSettingsBloc>(context)
                        .add(ChangedTimeOffUntil(timeUntil: TimeOfDay(hour: newValue.hour, minute: newValue.minute))),
                  )),
                ]),
              ],
            ),
          );
        });
  }
}
