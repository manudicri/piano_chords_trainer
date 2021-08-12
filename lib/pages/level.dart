import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:piano_chords_trainer/services/data.dart';
import 'package:piano_chords_trainer/services/midi.dart' as midi;
import 'package:piano_chords_trainer/services/mytimer.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/chord.dart';
import 'levelend.dart';

class LevelPage extends StatefulWidget {
  LevelPage({Key? key, required this.level}) : super(key: key);
  final String title = "Level Page";
  final int level;
  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  Random random = new Random();
  late StreamSubscription<String> _setupSubscription;
  late StreamSubscription<MidiPacket> _rxSubscription;
  List<int> keyboard = [];
  Chord? chord;
  bool waitForKeysUp = false;
  bool notCorrect = false;
  MyTimer timer = new MyTimer();
  int counter = 0;
  int counterMax = 20;
  Timer? _everyHalfSecond;

  String pickOne(String s) {
    var split = s.split("|");
    return split[random.nextInt(split.length)];
  }

  Chord generateChord() {
    var levelChordTypes =
        chordTypes.where((c) => c.levels.contains(widget.level)).toList();
    Chord chord = new Chord();
    chord
      ..type = levelChordTypes[random.nextInt(levelChordTypes.length)]
      ..offset = random.nextInt(12)
      ..text = pickOne(keyNotes[chord.offset]) + pickOne(chord.type!.text.short)
      ..notes = List.from(chord.type!.notes);

    return chord;
  }

  void waitNextChord() {
    if (!waitForKeysUp) {
      waitForKeysUp = true;
      if (counter == 0) timer.start();
      counter++;
      if (counter == counterMax) {
        timer.end();
        double seconds = timer.getSeconds();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LevelEndPage(seconds: seconds, level: widget.level),
          ),
        );
        counter = 0;
        timer.reset();
      }
    }
  }

  void nextChord() {
    if (waitForKeysUp) {
      waitForKeysUp = false;
      this.chord = generateChord();
    }
  }

  void processMidiInput(Uint8List data) {
    if (data.length < 3) return;
    var key = data[1];
    var down = data[0] == 144;
    if (down && !keyboard.contains(key)) {
      keyboard.add(key);
      var played = true;
      Chord chord = this.chord!;
      for (int n in chord.notes) {
        var notFound = true;
        for (int k in keyboard) {
          var key = (k) % 12;
          var note = (n + chord.offset) % 12;
          if (key == note) {
            notFound = false;
            break;
          }
        }
        if (notFound) played = false;
      }
      if (played) {
        waitNextChord();
      } else {
        notCorrect = true;
      }
    } else {
      keyboard = keyboard.where((i) => i != key).toList();
      if (keyboard.length == 0) {
        notCorrect = false;
        nextChord();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _setupSubscription = MidiCommand().onMidiSetupChanged!.listen((data) {
      switch (data) {
        case "deviceFound":
          setState(() {});
          break;
        default:
          break;
      }
    });
    this.chord = generateChord();

    MidiCommand().connectToDevice(midi.device!);
    this._rxSubscription = MidiCommand().onMidiDataReceived!.listen((packet) {
      var chunks = [];
      for (var i = 0; i < packet.data.length; i += 3) {
        chunks.add(packet.data.sublist(
            i, i + 3 > packet.data.length ? packet.data.length : i + 3));
      }
      for (var chunk in chunks) {
        processMidiInput(chunk);
      }
      setState(() {});
    });
    _everyHalfSecond = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (_everyHalfSecond != null) _everyHalfSecond!.cancel();
    //MidiCommand().stopScanningForBluetoothDevices();
    _rxSubscription.cancel();
    _setupSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[5],
      appBar: AppBar(
        title: Text("Level " + widget.level.toString()),
        brightness: Brightness.dark,
        backgroundColor: waitForKeysUp
            ? Color(0xff32a852)
            : notCorrect
                ? Color(0xffa31808)
                : colors[2],
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            height: 60,
            decoration: BoxDecoration(
              color: colors[5],
              border: Border.all(
                color: colors[5],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      counter.toString() + "/" + counterMax.toString(),
                      style: TextStyle(
                        color: colors[2],
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: Center(
                    child: Text(
                      timer.getSeconds().toString().split(".")[0] + "s",
                      style: TextStyle(
                        color: colors[2],
                        //fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: GestureDetector(
              child: Html(
                data: "<p>" + this.chord!.text + "</p>",
                style: {
                  "p": Style(
                    textAlign: TextAlign.center,
                    color: waitForKeysUp
                        ? Color(0xff32a852)
                        : notCorrect
                            ? Color(0xffa31808)
                            : Colors.black,
                    fontSize: FontSize.percent(600),
                  ),
                },
              ),
              /*
              child: Text(
                this.chord!.text,
                style: TextStyle(
                  fontSize: 100,
                  color: waitForKeysUp
                      ? Color(0xff32a852)
                      : notCorrect
                          ? Color(0xffa31808)
                          : Colors.black,
                ),
              ),*/
              onTap: () {
                assert(() {
                  setState(() {
                    waitNextChord();
                    nextChord();
                  });
                  return true;
                }());
              },
            ),
          ),
        ],
      ),
    );
  }
}
