class OptionModel {
  late String optionSize;
  late String optionPaperType;
  late String optionColor;
  late String optionSide;
  late String optionLayout;
  late String optionWrapping;
  String optionNote;
  // late double price;

  OptionModel({
    required this.optionSize,
    required this.optionPaperType,
    required this.optionColor,
    required this.optionSide,
    required this.optionLayout,
    required this.optionWrapping,
    required this.optionNote,
  });

  Map<String, dynamic> toMap() {
    return {
      'optionSize': optionSize,
      'optionPaperType': optionPaperType,
      'optionColor': optionColor,
      'optionSide': optionSide,
      'optionLayout': optionLayout,
      'optionWrapping': optionWrapping,
      'optionNote': optionNote
    };
  }
}
