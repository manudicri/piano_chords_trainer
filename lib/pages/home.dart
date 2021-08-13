import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:piano_chords_trainer/pages/level.dart';
import 'package:piano_chords_trainer/pages/settings.dart';
import 'package:piano_chords_trainer/services/data.dart';
import 'package:piano_chords_trainer/services/midi.dart' as midi;
import 'package:shared_preferences/shared_preferences.dart';
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
  LevelText("Level 16", "Dominant minor 9th chords"),
  LevelText("Level 17", "All 9th chords"),
  LevelText("Level 18", "All 7th & 9th chords"),
  LevelText("Level 19", "11th chords"),
  LevelText("Level 20", "Major 11th chords"),
  LevelText("Level 21", "Minor 11th chords"),
  LevelText("Level 22", "All 11th chords"),
  LevelText("Level 23", "All 7th, 9th & 11th chords"),
  LevelText("Level 24", "13th chords"),
  LevelText("Level 25", "Major 13th chords"),
  LevelText("Level 26", "Minor 13th chords"),
  LevelText("Level 27", "All chords"),
];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  final String title = "Home";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _stars = [];

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
                if (midi.connected) {
                  MidiCommand().disconnectDevice(midi.device!);
                  midi.connected = false;
                }
                if (!midi.connected) {
                  MidiCommand().connectToDevice(device);
                  midi.device = device;
                  midi.connected = true;
                }
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

  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;
    final List<DisplayMode> sameResolution = supported
        .where((DisplayMode m) =>
            m.width == active.width && m.height == active.height)
        .toList()
          ..sort((DisplayMode a, DisplayMode b) =>
              b.refreshRate.compareTo(a.refreshRate));
    final DisplayMode mostOptimalMode =
        sameResolution.isNotEmpty ? sameResolution.first : active;
    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }

  int getStarsByLevel(int level) {
    if (level > _stars.length) {
      return 0;
    } else {
      return _stars.elementAt(level - 1);
    }
  }

  void loadStars() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _stars = [];
      levelTexts.asMap().forEach((index, value) {
        int? stars = prefs.getInt("level" + (index + 1).toString());
        if (stars != null) {
          _stars.add(stars);
        } else {
          _stars.add(0);
        }
      });
    });
  }

  @override
  void initState() {
    setOptimalDisplayMode();
    loadStars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tileBorderRadius = 10;
    return Scaffold(
      backgroundColor: colors[5].withOpacity(0.98),
      appBar: AppBar(
        title: Text("Piano Chords Trainer"),
        brightness: Brightness.dark,
        actions: <Widget>[
          IconButton(
            icon: midi.connected ? Icon(Icons.piano) : Icon(Icons.piano_off),
            onPressed: showMidiDevicesDialog,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case "Settings":
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => SettingsPage(),
                        ),
                      )
                      .then((value) => loadStars());
                  break;
                case "Donate":
                  launch("https://ko-fi.com/manudicri");
                  break;
                case "Info":
                  showAboutDialog(context: context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {"Settings", "Donate", "Info"}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff3474e0), Color(0xff4881e3)]),
                  color: Color(0xff3474e0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(tileBorderRadius),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff3474e0).withOpacity(1), // 5c8fe6
                      spreadRadius: -7,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Color(0x11ffffff),
                    highlightColor: Colors.transparent,
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(tileBorderRadius)),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "ENDLESS RANDOM MODE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: levelTexts.length,
              itemBuilder: (context, index) {
                LevelText levelText = levelTexts[index];
                int stars = getStarsByLevel(index + 1);
                bool completed = stars == 5;
                return Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors[5],
                      borderRadius: BorderRadius.all(
                        Radius.circular(tileBorderRadius),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: -7,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(tileBorderRadius)),
                        onTap: () {
                          if (midi.connected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LevelPage(level: index + 1),
                              ),
                            ).then((context) {
                              loadStars();
                            });
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
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    levelText.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    levelText.subtitle,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff777777),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Text(
                                      stars.toString(),
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: completed
                                            ? Color(0xff3474e0)
                                            : colors[0],
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 22,
                                    color: completed
                                        ? Color(0xff3474e0)
                                        : colors[0],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
