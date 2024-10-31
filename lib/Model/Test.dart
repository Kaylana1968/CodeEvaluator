import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Test {
  String _label;
  mongo.ObjectId _category;
  List<mongo.ObjectId> _questions;

  static Test fromMap(Map<String, dynamic> map) {
    return Test(
      map['label'],
      List<mongo.ObjectId>.from(map['questions']),
      map['category'],
    );
  }

  Test(this._label, this._questions, this._category);

  Map<String, dynamic> toMap(){
    return {
      'label': label,
      'category': category,
      'questions': _questions
    };
  }

  String get label => _label;

  set label(String value) {
    _label = value;
  }

  List<mongo.ObjectId> get questions => _questions;

  set questions(List<mongo.ObjectId> value) {
    _questions = value;
  }

  mongo.ObjectId get category => _category;

  set category(mongo.ObjectId value) {
    _category = value;
  }
}