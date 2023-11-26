import 'package:flutter_boiler/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  Future<NumberTriviaModel> getConcreteNumberTrivia({required int number});
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
