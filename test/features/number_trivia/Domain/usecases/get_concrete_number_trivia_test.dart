import 'package:dartz/dartz.dart';
import 'package:flutter_boiler/features/number_trivia/Domain/entities/number_trivia.dart';
import 'package:flutter_boiler/features/number_trivia/Domain/repositories/number_trivia_repo.dart';
import 'package:flutter_boiler/features/number_trivia/Domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepo extends Mock implements NumberTriviaRepo {}

void main() {
  late MockNumberTriviaRepo mockNumberTriviaRepo;
  late GetConcreteNumberTrivia getConcreteNumberTrivia;
  setUp(() {
    mockNumberTriviaRepo = MockNumberTriviaRepo();
    getConcreteNumberTrivia = GetConcreteNumberTrivia(mockNumberTriviaRepo);
  });

  const numberTriviaParams = NumberTrivia.empty();
  final testNumberTrivia = NumberTrivia(
      text: numberTriviaParams.text, number: numberTriviaParams.number);
  const getNumberTriviaParams = GetNumberTriviaParams.empty();

  testWidgets('get concrete number trivia ...', (tester) async {
    //Arrange
    when(() => mockNumberTriviaRepo.getConcreteNumberTrivia(
            number: any(named: "number")))
        .thenAnswer((_) async => Right(testNumberTrivia));
    //Act
    final result = await getConcreteNumberTrivia(getNumberTriviaParams);
    //Assert
    expect(result, equals(Right<dynamic, NumberTrivia>(testNumberTrivia)));
    verify(() => mockNumberTriviaRepo.getConcreteNumberTrivia(
        number: getNumberTriviaParams.number)).called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepo);
  });
}
