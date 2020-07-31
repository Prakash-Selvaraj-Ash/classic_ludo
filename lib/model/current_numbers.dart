import 'dart:convert';

class CurrentNumber {
  bool isSelected;
  int currentNumber;
  CurrentNumber({
    this.isSelected,
    this.currentNumber,
  });

  CurrentNumber copyWith({
    bool isSelected,
    int currentNumber,
  }) {
    return CurrentNumber(
      isSelected: isSelected ?? this.isSelected,
      currentNumber: currentNumber ?? this.currentNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isSelected': isSelected,
      'currentNumber': currentNumber,
    };
  }

  static CurrentNumber fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CurrentNumber(
      isSelected: map['isSelected'],
      currentNumber: map['currentNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  static CurrentNumber fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() =>
      'CurrentNumber(isSelected: $isSelected, currentNumber: $currentNumber)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CurrentNumber &&
        o.isSelected == isSelected &&
        o.currentNumber == currentNumber;
  }

  @override
  int get hashCode => isSelected.hashCode ^ currentNumber.hashCode;
}
