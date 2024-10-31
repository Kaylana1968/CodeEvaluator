class Category {
  String _label;

  Category({required this.label});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    label: json["label"],
  );

  Category.clone(Category other) : _label = other.label;

  String get label => _label;

  Map<String, dynamic> toJson() => {
    "label": label,

  };
}