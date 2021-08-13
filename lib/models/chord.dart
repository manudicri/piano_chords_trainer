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

  set type(ChordType chordType) {
    this._type = chordType;
  }
}
