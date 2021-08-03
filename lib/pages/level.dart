import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:piano_chords_trainer/services/data.dart';
import 'package:piano_chords_trainer/services/midi.dart' as midi;
import 'package:piano_chords_trainer/services/mytimer.dart';

import '../models/chord.dart';

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
  Timer? _everyHalfSecond;

  String pickOne(String s) {
    var split = s.split("|");
    return split[random.nextInt(split.length)];
  }

  Chord generateChord() {
    Chord chord = new Chord();
    var levelChordTypes =
        chordTypes.where((c) => c.levels.contains(widget.level)).toList();

    chord.type = levelChordTypes[random.nextInt(levelChordTypes.length)];
    chord.offset = random.nextInt(12);
    chord.text =
        pickOne(keyNotes[chord.offset]) + pickOne(chord.type!.text.short);
    chord.notes = List.from(chord.type!.notes);

    return chord;
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
        waitForKeysUp = true;
        if (counter == 0) timer.start();
        counter++;
      } else {
        notCorrect = true;
      }
    } else {
      keyboard = keyboard.where((i) => i != key).toList();
      if (keyboard.length == 0) {
        notCorrect = false;
        if (waitForKeysUp) {
          waitForKeysUp = false;
          this.chord = generateChord();
        }
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
    /*
    _everyHalfSecond = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      setState(() {});
    });*/
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
        appBar: AppBar(
          title: Text("Level " + widget.level.toString()),
          brightness: Brightness.dark,
          backgroundColor: waitForKeysUp
              ? Color(0xff32a852)
              : notCorrect
                  ? Color(0xffa31808)
                  : colors[2],
        ),
        body: Column(
          children: [
            Container(
              child: Center(
                child: GestureDetector(
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
                  ),
                  onTap: () {
                    setState(() {
                      chord = generateChord();
                    });
                  },
                ),
              ),
            ),
            Container(
              child: Center(
                child: Text(timer.getSeconds().toString() + "s"),
              ),
            ),
          ],
        ));
  }
}
