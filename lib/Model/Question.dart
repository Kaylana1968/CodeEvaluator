import 'Category.dart';

class Question {
  String _label;
  List<Map<String, bool>> _choices;
  Category _category;

  Question(this._label, this._choices, this._category);

  Question.clone(Question other)
      : _label = other.label,
        _choices = List<Map<String, bool>>.from(other.choices),
        _category = Category.clone(other.category);

  String get label => _label;

  set label(String value) {
    _label = value;
  }

  List<Map<String, bool>> get choices => _choices;

  set choices(List<Map<String, bool>> value) {
    _choices = value;
  }

  Category get category => _category;

  set category(Category value) {
    _category = value;
  }
}
