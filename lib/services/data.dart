import 'package:flutter/material.dart';
import 'package:piano_chords_trainer/models/chord.dart';

const sup7 = "<sup>7</sup>";
const sup9 = "<sup>9</sup>";
const sup11 = "<sup>11</sup>";
const supMajor = "<sup>maj</sup>";
const supMinor = "<sup>min</sup>";

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
    [1, 3],
    50,
  ),
  new ChordType(
    "Minor triad",
    new ChordTypeText(
      "m|-",
      "min",
    ),
    [0, 3, 7],
    [2, 3],
    50,
  ),
  new ChordType(
    "Augmented triad",
    new ChordTypeText(
      "+",
      "aug",
    ),
    [0, 4, 8],
    [4],
    50,
  ),
  new ChordType(
    "Diminished triad",
    new ChordTypeText(
      "°",
      "dim",
    ),
    [0, 3, 6],
    [4],
    50,
  ),
  new ChordType(
    "Dominant seventh",
    new ChordTypeText(
      sup7,
      sup7,
    ),
    [0, 4, 7, 10],
    [4],
    50,
  ),
  new ChordType(
    "Major seventh",
    new ChordTypeText(
      "M" + sup7 + "|" + supMajor + sup7 + "|Δ" + sup7,
      "maj" + sup7,
    ),
    [0, 4, 7, 11],
    [4],
    50,
  ),
  new ChordType(
    "Minor seventh",
    new ChordTypeText(
      "m" + sup7 + "|-" + sup7,
      "min" + sup7,
    ),
    [0, 3, 7, 10],
    [4],
    50,
  ),
  new ChordType(
    "Major ninth",
    new ChordTypeText(
      "M" + sup9 + "|Δ" + sup9,
      "maj" + sup9,
    ),
    [0, 4, 7, 11, 2],
    [4],
    50,
  ),
  new ChordType(
    "Dominant ninth",
    new ChordTypeText(
      sup9,
      sup9,
    ),
    [0, 4, 7, 10, 2],
    [4],
    50,
  ),
  new ChordType(
    "Dominant minor ninth",
    new ChordTypeText(
      sup7 + "♭" + sup9,
      sup7 + "♭" + sup9,
    ),
    [0, 4, 7, 10, 1],
    [4],
    50,
  ),
  new ChordType(
    "Minor ninth",
    new ChordTypeText(
      "m" + sup9 + "|-" + sup9,
      "min" + sup9,
    ),
    [0, 3, 7, 10, 2],
    [4],
    50,
  ),
  new ChordType(
    "Eleventh",
    new ChordTypeText(
      sup11,
      sup11,
    ),
    [0, 4, 7, 10, 2, 5],
    [4],
    50,
  ),
  new ChordType(
    "Major eleventh",
    new ChordTypeText(
      "M" + sup11,
      "maj" + sup11,
    ),
    [0, 4, 7, 11, 2, 5],
    [4],
    50,
  ),
  new ChordType(
    "Minor eleventh",
    new ChordTypeText(
      "m" + sup11 + "|-" + sup11,
      "min" + sup11,
    ),
    [0, 3, 7, 10, 2, 5],
    [4],
    50,
  ),
];

List<Color> colors = [
  Color(0xff000000),
  Color(0xff151926),
  Color(0xff2f3146),
  Color(0xff5f6c7f),
  Color(0xffd5dce6),
  Color(0xfff8fcff),
];
