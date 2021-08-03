int nowMs() {
  return DateTime.now().millisecondsSinceEpoch;
}

class MyTimer {
  int _startTime = 0;
  int _endTime = 0;
  bool _on = false;

  start() {
    this._startTime = nowMs();
    this._on = true;
  }

  end() {
    this._on = false;
    this._endTime = nowMs();
  }

  getSeconds() {
    var end = this._on ? nowMs() : this._endTime;
    return (end - this._startTime) / 1000;
  }
}
