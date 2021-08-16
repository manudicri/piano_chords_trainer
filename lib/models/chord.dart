import 'dart:math';

import 'package:piano_chords_trainer/services/data.dart';

class ChordType {
  String name;
  ChordTypeText text;
  List<int> notes = [];
  List<int> levels = [];
  int prob = 0;
  ChordType({
    this.name = "",
    this.text = const ChordTypeText(),
    this.notes = const [],
    this.levels = const [],
    this.prob = 100,
  });

  //ChordType(this.name, this.text, this.notes, this.levels, this.prob);
  //ChordType({name: name, text: text, notes: notes, prob: prob});
}

class ChordTypeText {
  final String short;
  final String long;
  const ChordTypeText({
    this.short = "",
    this.long = "",
  });
}

class ChordSus {
  String name;
  String text;
  int note;
  List<int> levels;
  ChordSus({
    this.name = "",
    this.text = "",
    this.note = 0,
    this.levels = const [],
  });
}

class ChordAdd {
  String text;
  int note;
  List<int> levels;
  ChordAdd({
    this.text = "",
    this.note = 0,
    this.levels = const [],
  });
}

class Chord {
  ChordType? _type;
  int offset = 0;
  List<int> notes = [];
  ChordAdd? add;
  ChordSus? sus;
  String text = "";

  ChordType get type {
    return this._type ?? ChordType();
  }

  ChordType setRandomChordType() {
    Random random = Random();
    double u = chordTypes.fold(0, (sum, item) => sum + item.prob);
    double r = random.nextDouble() * u;
    double sum = 0;
    for (ChordType n in chordTypes) {
      if (r <= (sum = sum + n.prob)) {
        this._type = n;
        return type;
      }
    }
    return type;
  }

  set type(ChordType chordType) {
    this._type = chordType;
  }
}
