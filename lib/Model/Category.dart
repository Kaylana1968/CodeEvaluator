class Category {
  String _label;

  Category(this._label);

  Category.clone(Category other) : _label = other.label;

  String get label => _label;

  set label(String value) {
    _label = value;
  }
}
