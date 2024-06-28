class SortModel {
  dynamic id;
  String? name;
  String? icon;
  bool? isSelected;

  bool get isNameAToZ => id == 1;
  bool get isNameZToA => id == 2;
  bool get isByType => id == 3;
  bool get isDateAToZ => id == 4;
  bool get isDateZToA => id == 5;
  bool get isByLengthIncrement => id == 6;
  bool get isByLengthDecrement => id == 7;

  SortModel({
    this.id,
    this.name,
    this.icon,
    this.isSelected,
  });
}
