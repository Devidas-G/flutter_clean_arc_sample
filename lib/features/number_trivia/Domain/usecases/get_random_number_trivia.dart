import 'package:flutter_boiler/core/usecase/usecase.dart';
import 'package:flutter_boiler/core/utils/typedef.dart';
import 'package:flutter_boiler/features/number_trivia/Domain/entities/number_trivia.dart';
import 'package:flutter_boiler/features/number_trivia/Domain/repositories/number_trivia_repo.dart';

class GetRandomNumberTrivia extends UseCaseWithoutParams {
  final NumberTriviaRepo _repo;

  GetRandomNumberTrivia(this._repo);
  @override
  ResultFuture<NumberTrivia> call() async => _repo.getRandomNumberTrivia();
}
