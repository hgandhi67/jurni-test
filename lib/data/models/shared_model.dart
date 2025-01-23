import 'package:equatable/equatable.dart';

class SharedModel with EquatableMixin {
  String? title;
  String? question;
  bool isSelected;
  List<SharedModel>? options;
  List<SharedModel>? options2;
  int? value;

  SharedModel({
    this.title,
    this.question,
    this.options,
    this.options2,
    this.value,
    this.isSelected = false,
  });

  @override
  List<Object?> get props => [
        title,
        question,
        options,
        isSelected,
        value,
      ];
}
