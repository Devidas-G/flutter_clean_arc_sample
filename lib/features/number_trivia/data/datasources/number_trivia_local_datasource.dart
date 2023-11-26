import 'package:flutter_boiler/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  Future<NumberTriviaModel> getLastNumberTrivia({required int number});
  Future<void> cacheNumberTrivia(
      {required NumberTriviaModel numberTriviaModel});
}
