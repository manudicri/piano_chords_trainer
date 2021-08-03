class ChordType {
  String name;
  ChordTypeText text;
  List<int> notes = [];
  List<int> levels = [];
  int prob = 0;
  ChordType(this.name, this.text, this.notes, this.levels, this.prob);
  //ChordType({name: name, text: text, notes: notes, prob: prob});
}

class ChordTypeText {
  String short;
  String long;
  ChordTypeText(this.short, this.long);
}

class ChordSus {
  String name;
  String text;
  int note;
  ChordSus(this.name, this.text, this.note);
}

class ChordAdd {
  String text;
  int number;
  ChordAdd(this.text, this.number);
}

class Chord {
  ChordType? type;
  int offset = 0;
  List<int> notes = [];
  ChordAdd? add;
  ChordSus? sus;
  String text = "";
}
