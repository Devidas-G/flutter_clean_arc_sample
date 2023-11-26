import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_boiler/core/errors/exception.dart';
import 'package:flutter_boiler/core/errors/failure.dart';
import 'package:flutter_boiler/core/platform/network_info.dart';
import 'package:flutter_boiler/features/number_trivia/Domain/entities/number_trivia.dart';
import 'package:flutter_boiler/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_boiler/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_boiler/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_boiler/features/number_trivia/data/repositories/number_trivia_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late NumberTriviaRepoImpl repoImpl;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repoImpl = NumberTriviaRepoImpl(
        remoteDatasource: mockRemoteDataSource,
        localDatasource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('get concrete number trivia', () {
    final NumberTriviaModel numberTriviaModel =
        NumberTriviaModel(text: "text", number: 1);
    final NumberTrivia numberTrivia = numberTriviaModel;
    test('should check if device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      final result = await mockNetworkInfo.isConnected;
      //assert
      expect(result, true);
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    group("device in online", () {
      setUp(() => when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true));
      test('should return remote data on success', () async {
        //arrange
        when(
          () => mockRemoteDataSource.getConcreteNumberTrivia(
              number: any(named: "number")),
        ).thenAnswer((_) async => numberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(
                numberTriviaModel: numberTriviaModel))
            .thenAnswer((invocation) => Future<void>(() => null));
        //act
        final result = await repoImpl.getConcreteNumberTrivia(number: 1);
        //assert
        expect(result, equals(Right<dynamic, NumberTrivia>(numberTrivia)));
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(number: 1))
            .called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
      test('should cache remote data on success', () async {
        //arrange
        when(
          () => mockRemoteDataSource.getConcreteNumberTrivia(
              number: any(named: "number")),
        ).thenAnswer((_) async => numberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(
                numberTriviaModel: numberTriviaModel))
            .thenAnswer((invocation) => Future<void>(() => null));
        //act
        await repoImpl.getConcreteNumberTrivia(number: 1);
        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(number: 1))
            .called(1);
        verify(() => mockLocalDataSource.cacheNumberTrivia(
            numberTriviaModel: numberTriviaModel)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
      test('should return cache failure when remote data on success', () async {
        //arrange
        when(
          () => mockRemoteDataSource.getConcreteNumberTrivia(
              number: any(named: "number")),
        ).thenAnswer((_) async => numberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(
            numberTriviaModel: numberTriviaModel)).thenThrow(CacheException());
        //act
        final result = await repoImpl.getConcreteNumberTrivia(number: 1);
        //assert
        expect(
            result,
            equals(
                const Left(CacheFailure(message: "message", statusCode: 1))));
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(number: 1))
            .called(1);
        verify(() => mockLocalDataSource.cacheNumberTrivia(
            numberTriviaModel: numberTriviaModel)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
      test('should return api failure when remote unsuccessfull', () async {
        //arrange
        when(
          () => mockRemoteDataSource.getConcreteNumberTrivia(
              number: any(named: "number")),
        ).thenThrow(ApiException());
        //act
        final result = await repoImpl.getConcreteNumberTrivia(number: 1);
        //assert
        expect(result,
            equals(const Left(ApiFailure(message: "message", statusCode: 1))));
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(number: 1))
            .called(1);
        verifyZeroInteractions(mockLocalDataSource);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
    });
    group("device in offline", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((invocation) async => false);
      });
      test("should return cached number trivia", () async {
        //arange
        when(() => mockLocalDataSource.getLastNumberTrivia(number: 1))
            .thenAnswer((_) async => numberTriviaModel);
        //act
        final result = await repoImpl.getConcreteNumberTrivia(number: 1);
        //assert
        expect(result, equals(Right<dynamic, NumberTrivia>(numberTrivia)));
        verify(() => mockLocalDataSource.getLastNumberTrivia(number: 1))
            .called(1);
        verifyZeroInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
      test("should return cached failure when local unsuccesfull", () async {
        //arange
        when(() => mockLocalDataSource.getLastNumberTrivia(number: 1))
            .thenThrow(CacheException());
        //act
        final result = await repoImpl.getConcreteNumberTrivia(number: 1);
        //assert
        expect(
            result,
            equals(
                const Left(CacheFailure(message: "message", statusCode: 1))));
        verify(() => mockLocalDataSource.getLastNumberTrivia(number: 1))
            .called(1);
        verifyZeroInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
    });
  });
}
