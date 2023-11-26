import 'package:flutter_boiler/features/number_trivia/Domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required super.text, required super.number});
  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'] as String,
      number: (json['number'] as num).toInt(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
