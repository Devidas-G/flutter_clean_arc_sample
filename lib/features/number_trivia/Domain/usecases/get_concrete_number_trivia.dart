import 'package:equatable/equatable.dart';
import 'package:flutter_boiler/core/usecase/usecase.dart';
import 'package:flutter_boiler/core/utils/typedef.dart';
import 'package:flutter_boiler/features/number_trivia/Domain/entities/number_trivia.dart';

import '../repositories/number_trivia_repo.dart';

class GetConcreteNumberTrivia
    extends UseCaseWithParams<void, GetNumberTriviaParams> {
  final NumberTriviaRepo _repo;

  GetConcreteNumberTrivia(this._repo);
  @override
  ResultFuture<NumberTrivia> call(GetNumberTriviaParams params) async =>
      _repo.getConcreteNumberTrivia(number: params.number);
}

class GetNumberTriviaParams extends Equatable {
  const GetNumberTriviaParams({required this.number});

  const GetNumberTriviaParams.empty()
      : this(
          number: 1,
        );
  final int number;

  @override
  List<Object?> get props => [number];
}
