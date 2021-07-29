import 'dart:math';

import 'package:flutter/material.dart';

import 'chord.dart';

void main() {
  runApp(MyApp());
}

const sup7 = "\u2077";
const sup9 = "\u2079";
const sup11 = "\u00B9\u00B9";
const supM = "\u1d50";
const supMajor = supM + "\u1d43\u02b2";
const supMinor = supM + "\u2071\u1d50";
List<String> keyNotes = [
  "C",
  "C♯|D♭",
  "D",
  "D♯|E♭",
  "E",
  "F",
  "F♯|G♭",
  "G",
  "G♯|A♭",
  "A",
  "A♯|B♭",
  "B"
];

List<ChordType> chordTypes = [
  new ChordType(
    "Major triad",
    new ChordTypeText(
      "|M|Δ",
      "maj",
    ),
    [0, 4, 7],
    50,
  ),
  new ChordType(
    "Minor triad",
    new ChordTypeText(
      "m|-",
      "min",
    ),
    [0, 3, 7],
    50,
  ),
  new ChordType(
    "Augmented triad",
    new ChordTypeText(
      "+",
      "aug",
    ),
    [0, 4, 8],
    50,
  ),
  new ChordType(
    "Diminished triad",
    new ChordTypeText(
      "°",
      "dim",
    ),
    [0, 3, 6],
    50,
  ),
  new ChordType(
    "Dominant seventh",
    new ChordTypeText(
      sup7,
      sup7,
    ),
    [0, 4, 7, 10],
    50,
  ),
  new ChordType(
    "Major seventh",
    new ChordTypeText(
      "M" + sup7 + "|" + supMajor + sup7 + "|Δ" + sup7,
      "maj" + sup7,
    ),
    [0, 4, 7, 11],
    50,
  ),
  new ChordType(
    "Minor seventh",
    new ChordTypeText(
      "m" + sup7 + "|-" + sup7,
      "min" + sup7,
    ),
    [0, 3, 7, 10],
    50,
  ),
  new ChordType(
    "Major ninth",
    new ChordTypeText(
      "M" + sup9 + "|Δ" + sup9,
      "maj" + sup9,
    ),
    [0, 4, 7, 11, 2],
    50,
  ),
  new ChordType(
    "Dominant ninth",
    new ChordTypeText(
      sup9,
      sup9,
    ),
    [0, 4, 7, 10, 2],
    50,
  ),
  new ChordType(
    "Dominant minor ninth",
    new ChordTypeText(
      sup7 + "♭" + sup9,
      sup7 + "♭" + sup9,
    ),
    [0, 4, 7, 10, 1],
    50,
  ),
  new ChordType(
    "Minor ninth",
    new ChordTypeText(
      "m" + sup9 + "|-" + sup9,
      "min" + sup9,
    ),
    [0, 3, 7, 10, 2],
    50,
  ),
  new ChordType(
    "Eleventh",
    new ChordTypeText(
      sup11,
      sup11,
    ),
    [0, 4, 7, 10, 2, 5],
    50,
  ),
  new ChordType(
    "Major eleventh",
    new ChordTypeText(
      "M" + sup11,
      "maj" + sup11,
    ),
    [0, 4, 7, 11, 2, 5],
    50,
  ),
  new ChordType(
    "Minor eleventh",
    new ChordTypeText(
      "m" + sup11 + "|-" + sup11,
      "min" + sup11,
    ),
    [0, 3, 7, 10, 2, 5],
    50,
  ),
];

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryBlack,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Random random = new Random();

  String pickOne(String s) {
    var split = s.split("|");
    return split[random.nextInt(split.length)];
  }

  Chord generateChord() {
    Chord chord = new Chord();
    chord.type = chordTypes[random.nextInt(chordTypes.length)];
    chord.offset = random.nextInt(12);
    chord.text =
        pickOne(keyNotes[chord.offset]) + pickOne(chord.type!.text.short);
    return chord;
  }

  @override
  Widget build(BuildContext context) {
    Chord chord = generateChord();
    return Scaffold(
      appBar: AppBar(
        title: Text("Piano Chords Trainer"),
      ),
      body: Container(
        child: Center(
          child: GestureDetector(
            child: Text(
              chord.text,
              style: TextStyle(fontSize: 100),
            ),
            onTap: () {
              setState(() {
                chord = generateChord();
              });
            },
          ),
        ),
      ),
    );
  }
}
