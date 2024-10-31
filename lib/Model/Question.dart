import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Choice {
  String _choiceLabel;
  bool _isGood;

  static Choice fromMap(Map<String, dynamic> map) {
    return Choice(
      map['choiceLabel'],
      map['isGood'],
    );
  }

  Choice(this._choiceLabel, this._isGood);

  bool get isGood => _isGood;

  set isGood(bool value) {
    _isGood = value;
  }

  String get choiceLabel => _choiceLabel;

  set choiceLabel(String value) {
    _choiceLabel = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'choiceLabel': choiceLabel,
      'isGood': isGood,
    };
  }
}

class Question {
  String _label;
  List<Choice> _choices;
  mongo.ObjectId _category;

  Question(this._label, this._choices, this._category);

  Question.clone(Question other)
      : _label = other.label,
        _choices = List<Choice>.from(other.choices),
        _category = other.category;

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'choices': choices.map((choice) => choice.toMap()).toList(),
      'category': category,
    };
  }

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      map['label'],
      (map['choices'] as List)
          .map((choice) => Choice.fromMap(choice as Map<String, dynamic>))
          .toList(),
      map['category'],
    );
  }

  String get label => _label;

  set label(String value) {
    _label = value;
  }

  List<Choice> get choices => _choices;

  set choices(List<Choice> value) {
    _choices = value;
  }

  mongo.ObjectId get category => _category;

  set category(mongo.ObjectId value) {
    _category = value;
  }
}
