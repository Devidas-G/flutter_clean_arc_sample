import 'dart:convert';

import 'package:flutter_boiler/features/number_trivia/Domain/entities/number_trivia.dart';
import 'package:flutter_boiler/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const numberTriviaModel = NumberTriviaModel(text: "test", number: 1);
  testWidgets('number trivia model ...', (tester) async {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });
  group("fromJson", () {
    test('should return a valid model when json is a integer', () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('number_trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, equals(numberTriviaModel));
    });
    test('should return a valid model when json is regarded as double',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('number_trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, equals(numberTriviaModel));
    });
  });
  group("toJson", () {
    test('should return a valid json when provide a model', () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('number_trivia.json'));
      final expectedjson = {
        "text": "test",
        "number": 1,
      };
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      final json = result.toJson();
      //assert
      expect(json, equals(expectedjson));
    });
    test('should return a valid json when provide a model double', () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('number_trivia_double.json'));
      final expectedjson = {
        "text": "test",
        "number": 1,
      };
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      final json = result.toJson();
      //assert
      expect(json, equals(expectedjson));
    });
  });
}
