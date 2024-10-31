class Category {
  String _label;

  Category(this._label);

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        json["label"],
      );

  Category.clone(Category other) : _label = other.label;

  String get label => _label;

  Map<String, dynamic> toJson() => {
        "label": label,
      };
}
