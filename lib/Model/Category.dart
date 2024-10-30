
class Category {
  String label;

  Category({required this.label});



  factory Category.fromJson(Map<String, dynamic> json) => Category(
    label: json["label"],

  );

  Map<String, dynamic> toJson() => {
    "label": label,

  };
}

