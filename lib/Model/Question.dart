class Question {
  String _label;
  int _answer;
  List<String> _choices;
  String _category;

  Question(this._label, this._answer, this._choices, this._category);

  String get label => _label;

  set label(String value) {
    _label = value;
  }

  int get answer => _answer;

  set answer(int value) {
    _answer = value;
  }

  List<String> get choices => _choices;

  set choices(List<String> value) {
    _choices = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }
}