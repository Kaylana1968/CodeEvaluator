import 'Category.dart';

class Question {
  String _label;
  List<int> _answer;
  List<String> _choices;
  Category _category;

  Question(this._label, this._answer, this._choices, this._category);

  String get label => _label;

  set label(String value) {
    _label = value;
  }

  List<int> get answer => _answer;

  set answer(List<int> value) {
    _answer = value;
  }

  List<String> get choices => _choices;

  set choices(List<String> value) {
    _choices = value;
  }

  Category get category => _category;

  set category(Category value) {
    _category = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'answer': answer,
      'choices': choices,
      'category': category,
    };
  }
}
