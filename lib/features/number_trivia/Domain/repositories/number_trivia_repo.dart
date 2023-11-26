import 'package:flutter_boiler/features/number_trivia/Domain/entities/number_trivia.dart';

import '../../../../core/utils/typedef.dart';

abstract class NumberTriviaRepo {
  ResultFuture<NumberTrivia> getConcreteNumberTrivia({required int number});
  ResultFuture<NumberTrivia> getRandomNumberTrivia();
}
