import 'package:flutter/material.dart';
import 'package:piano_chords_trainer/models/chord.dart';

const sup7 = "<sup>7</sup>";
const sup9 = "<sup>9</sup>";
const sup11 = "<sup>11</sup>";
const sup13 = "<sup>13</sup>";
const sup69 = "<sup>6/9</sup>";
const sup6 = "<sup>6</sup>";
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
  ChordType(
    name: "Major triad",
    text: ChordTypeText(
      short: "|M|Δ",
      long: "maj",
    ),
    notes: [0, 4, 7],
    levels: [1, 3, 8, 12, 27],
    prob: 50,
  ),
  ChordType(
    name: "Minor triad",
    text: ChordTypeText(
      short: "m|-",
      long: "min",
    ),
    notes: [0, 3, 7],
    levels: [2, 3, 8, 12, 27],
    prob: 50,
  ),
  ChordType(
    name: "Augmented triad",
    text: ChordTypeText(
      short: "+",
      long: "aug",
    ),
    notes: [0, 4, 8],
    levels: [9, 11, 12, 27],
  ),
  ChordType(
    name: "Diminished triad",
    text: ChordTypeText(
      short: "°",
      long: "dim",
    ),
    notes: [0, 3, 6],
    levels: [10, 11, 12, 27],
    prob: 50,
  ),
  ChordType(
    name: "Dominant seventh",
    text: ChordTypeText(
      short: sup7,
      long: sup7,
    ),
    notes: [0, 4, 7, 10],
    levels: [6, 7, 8, 18, 23, 27],
    prob: 50,
  ),
  ChordType(
    name: "Major seventh",
    text: new ChordTypeText(
      short: "M" + sup7 + "|" + supMajor + sup7 + "|Δ" + sup7,
      long: "maj" + sup7,
    ),
    notes: [0, 4, 7, 11],
    levels: [4, 7, 8, 18, 23, 27],
    prob: 50,
  ),
  ChordType(
    name: "Minor seventh",
    text: ChordTypeText(
      short: "m" + sup7 + "|-" + sup7,
      long: "min" + sup7,
    ),
    notes: [0, 3, 7, 10],
    levels: [5, 7, 8, 18, 23, 27],
    prob: 50,
  ),
  ChordType(
    name: "Major ninth",
    text: ChordTypeText(
      short: "M" + sup9 + "|Δ" + sup9,
      long: "maj" + sup9,
    ),
    notes: [0, 4, 7, 11, 2],
    levels: [13, 17, 18, 23, 27],
    prob: 50,
  ),
  ChordType(
    name: "Dominant ninth",
    text: ChordTypeText(
      short: sup9,
      long: sup9,
    ),
    notes: [0, 4, 7, 10, 2],
    levels: [15, 17, 18, 23, 27],
    prob: 50,
  ),
  ChordType(
    name: "Dominant minor ninth",
    text: ChordTypeText(
      short: sup7 + "♭" + sup9,
      long: sup7 + "♭" + sup9,
    ),
    notes: [0, 4, 7, 10, 1],
    levels: [16, 17, 18, 23, 27],
    prob: 50,
  ),
  ChordType(
    name: "Minor ninth",
    text: ChordTypeText(
      short: "m" + sup9 + "|-" + sup9,
      long: "min" + sup9,
    ),
    notes: [0, 3, 7, 10, 2],
    levels: [14, 17, 18, 23, 27],
    prob: 50,
  ),
  ChordType(
    name: "Eleventh",
    text: ChordTypeText(
      short: sup11,
      long: sup11,
    ),
    notes: [0, 4, 7, 10, 2, 5],
    levels: [19, 22, 23, 27],
    prob: 50,
  ),
  ChordType(
    name: "Major eleventh",
    text: ChordTypeText(
      short: "M" + sup11,
      long: "maj" + sup11,
    ),
    notes: [0, 4, 7, 11, 2, 5],
    levels: [20, 22, 23, 27],
    prob: 50,
  ),
  ChordType(
    name: "Minor eleventh",
    text: ChordTypeText(
      short: "m" + sup11 + "|-" + sup11,
      long: "min" + sup11,
    ),
    notes: [0, 3, 7, 10, 2, 5],
    levels: [21, 22, 23, 27],
    prob: 50,
  ),
  ChordType(
    name: "Major thirteenth",
    text: ChordTypeText(
      short: "M" + sup13 + "|Δ" + sup13,
      long: "maj" + sup13,
    ),
    notes: [0, 4, 7, 11, 2, 5, 9],
    levels: [25, 27],
    prob: 50,
  ),
  ChordType(
    name: "Thirteenth",
    text: ChordTypeText(
      short: sup13,
      long: sup13,
    ),
    notes: [0, 4, 7, 10, 2, 5, 9],
    levels: [24, 27],
  ),
  ChordType(
    name: "Minor thirteenth",
    text: ChordTypeText(
      short: "m" + sup13 + "|-" + sup13,
      long: "min" + sup13,
    ),
    notes: [0, 3, 7, 11, 2, 5, 9],
    levels: [26, 27],
  ),
  ChordType(
    name: "6/9",
    text: ChordTypeText(
      short: sup69,
      long: sup69,
    ),
    notes: [0, 4, 7, 9],
    levels: [0],
    prob: 50,
  ),
  ChordType(
    name: "Major sixth",
    text: ChordTypeText(
      short: sup6,
      long: sup6,
    ),
    notes: [0, 4, 7, 9],
  ),
  ChordType(
    name: "Minor sixth",
    text: ChordTypeText(
      short: "m" + sup6,
      long: "minor" + sup6,
    ),
    notes: [0, 3, 7, 9],
  ),
];

List<ChordSus> chordSus = [
  ChordSus(
    name: "Suspended fourth",
    text: "<sup>sus4</sup>|<sup>sus</sup>",
    note: 5,
  ),
  ChordSus(
    name: "Suspended second",
    text: "<sup>sus2</sup>|<sup>sus</sup>",
    note: 2,
  ),
];
List<ChordAdd> chordAdds = [
  ChordAdd(
    text: "2|9",
    note: 2,
  ),
  ChordAdd(
    text: "6|13",
    note: 9,
  ),
  ChordAdd(
    text: "4|11",
    note: 5,
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
