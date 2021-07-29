class ChordType {
  String name;
  ChordTypeText text;
  List<int> notes;
  int prob;
  ChordType(this.name, this.text, this.notes, this.prob);
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
  List<String> notes = [];
  ChordAdd? add;
  ChordSus? sus;
  String text = "";
}
