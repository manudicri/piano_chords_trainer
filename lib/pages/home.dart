import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:piano_chords_trainer/pages/level.dart';
import 'package:piano_chords_trainer/services/midi.dart' as midi;
import 'package:url_launcher/url_launcher.dart';

class LevelText {
  String title = "";
  String subtitle = "";
  LevelText(this.title, this.subtitle);
}

List<LevelText> levelTexts = [
  LevelText("Level 1", "Major triad chords"),
  LevelText("Level 2", "Minor triad chords"),
  LevelText("Level 3", "Major and minor triad chords"),
  LevelText("Level 4", "Major 7th chords"),
  LevelText("Level 5", "Minor 7th chords"),
  LevelText("Level 6", "Dominant 7th chords"),
  LevelText("Level 7", "All 7th chords"),
  LevelText("Level 8", "Major, minor and 7th chords"),
  LevelText("Level 9", "Augmented chords"),
  LevelText("Level 10", "Diminished chords"),
  LevelText("Level 11", "Augmented and diminished chords"),
  LevelText("Level 12", "Major, minor, aug, dim chords"),
  LevelText("Level 13", "Major 9th chords"),
  LevelText("Level 14", "Minor 9th chords"),
  LevelText("Level 15", "Dominant 9th chords"),
  LevelText("Level 16", "Dominant major 9th chords"),
  LevelText("Level 17", "Dominant minor 9th chords")
];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  final String title = "Home";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getMidiDevices() async {
    List<MidiDevice>? devices = await MidiCommand().devices;
    return devices;
  }

  Widget midiDevicesWidget() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData || snapshot.data == null)
          return Text('No devices found..');
        var devices = snapshot.data as List<MidiDevice>;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: devices.length,
          itemBuilder: (context, index) {
            MidiDevice device = devices[index];
            return ListTile(
              title: Text(
                device.name,
              ),
              subtitle: Text(
                  "ins:${device.inputPorts.length} outs:${device.outputPorts.length}"),
              trailing: device.type == "BLE" ? Icon(Icons.bluetooth) : null,
              onTap: () {
                Navigator.pop(context);
                midi.connected = true;
                midi.device = device;
                setState(() {});
              },
            );
          },
        );
      },
      future: getMidiDevices(),
    );
  }

  showMidiDevicesDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Select a MIDI Device"),
        content: Container(
          width: 300.0,
          child: midiDevicesWidget(),
        ),
      ),
    ).then((val) {
      //MidiCommand().stopScanningForBluetoothDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Piano Chords Trainer"),
        brightness: Brightness.dark,
        actions: [
          IconButton(
            icon: Icon(Icons.coffee_rounded),
            onPressed: () => {launch("https://ko-fi.com/manudicri")},
          ),
          IconButton(
            icon: midi.connected ? Icon(Icons.piano) : Icon(Icons.piano_off),
            onPressed: showMidiDevicesDialog,
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: levelTexts.length,
          itemBuilder: (context, index) {
            var levelText = levelTexts[index];
            return ListTile(
              title: Text(levelText.title),
              subtitle: Text(levelText.subtitle),
              onTap: () {
                if (midi.connected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LevelPage(level: index + 1),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Warning"),
                        content: Text("Connect to MIDI device first"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                              showMidiDevicesDialog();
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
