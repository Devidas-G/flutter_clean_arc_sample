import 'package:dartz/dartz.dart';
import 'package:flutter_boiler/core/errors/exception.dart';
import 'package:flutter_boiler/core/errors/failure.dart';
import 'package:flutter_boiler/core/platform/network_info.dart';
import 'package:flutter_boiler/core/utils/typedef.dart';

import 'package:flutter_boiler/features/number_trivia/Domain/entities/number_trivia.dart';
import 'package:flutter_boiler/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_boiler/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';

import '../../Domain/repositories/number_trivia_repo.dart';

class NumberTriviaRepoImpl implements NumberTriviaRepo {
  final NumberTriviaRemoteDatasource remoteDatasource;
  final NumberTriviaLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  NumberTriviaRepoImpl(
      {required this.remoteDatasource,
      required this.localDatasource,
      required this.networkInfo});

  @override
  ResultFuture<NumberTrivia> getConcreteNumberTrivia(
      {required int number}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteresult =
            await remoteDatasource.getConcreteNumberTrivia(number: number);
        try {
          await localDatasource.cacheNumberTrivia(
              numberTriviaModel: remoteresult);
        } on CacheException {
          return const Left(CacheFailure(message: "message", statusCode: 1));
        }
        return Right(remoteresult);
      } on ApiException {
        return const Left(ApiFailure(message: "message", statusCode: 1));
      }
    } else {
      try {
        final localresult =
            await localDatasource.getLastNumberTrivia(number: number);
        return Right(localresult);
      } on CacheException {
        return const Left(CacheFailure(message: "message", statusCode: 1));
      }
    }
  }

  @override
  ResultFuture<NumberTrivia> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
