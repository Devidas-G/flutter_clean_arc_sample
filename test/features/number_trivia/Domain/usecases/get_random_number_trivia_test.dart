import 'package:dartz/dartz.dart';
import 'package:flutter_boiler/features/number_trivia/Domain/entities/number_trivia.dart';
import 'package:flutter_boiler/features/number_trivia/Domain/repositories/number_trivia_repo.dart';
import 'package:flutter_boiler/features/number_trivia/Domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepo extends Mock implements NumberTriviaRepo {}

void main() {
  late MockNumberTriviaRepo mockNumberTriviaRepo;
  late GetRandomNumberTrivia getRandomNumberTrivia;
  setUp(() {
    mockNumberTriviaRepo = MockNumberTriviaRepo();
    getRandomNumberTrivia = GetRandomNumberTrivia(mockNumberTriviaRepo);
  });
  const numberTriviaParams = NumberTrivia.empty();
  final testNumberTrivia = NumberTrivia(
      text: numberTriviaParams.text, number: numberTriviaParams.number);

  testWidgets('get random number trivia ...', (tester) async {
    // Arrange
    when(() => mockNumberTriviaRepo.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(testNumberTrivia));
    // Act
    final result = await getRandomNumberTrivia();
    // Assert
    expect(result, equals(Right<dynamic, NumberTrivia>(testNumberTrivia)));
    verify(() => mockNumberTriviaRepo.getRandomNumberTrivia()).called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepo);
  });
}
