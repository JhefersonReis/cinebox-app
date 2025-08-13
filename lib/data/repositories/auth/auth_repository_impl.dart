import 'dart:developer';

import 'package:cinebox/core/result/result.dart';
import 'package:cinebox/data/exceptions/data_exception.dart';
import 'package:cinebox/data/service/auth/auth_service.dart';
import 'package:cinebox/data/service/google_signin/google_signin_service.dart';
import 'package:cinebox/data/service/local_storage/local_storage_service.dart';
import 'package:dio/dio.dart';

import './auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalStorageService _localStorageService;
  final GoogleSigninService _googleSigninService;
  final AuthService _authService;

  AuthRepositoryImpl({
    required LocalStorageService localStorageService,
    required GoogleSigninService googleSigninService,
    required AuthService authService,
  }) : _localStorageService = localStorageService,
       _googleSigninService = googleSigninService,
       _authService = authService;

  @override
  Future<Result<bool>> isLogged() async {
    final resultToken = await _localStorageService.getIdToken();

    return switch (resultToken) {
      Success<String>() => Success(true),
      Failure<String>() => Success(false),
    };
  }

  @override
  Future<Result<Unit>> signIn() async {
    final result = await _googleSigninService.signIn();

    switch (result) {
      case Success<String>(:final value):
        try {
          await _localStorageService.saveIdToken(value);
          await _authService.auth();
          return succesOfUnit();
        } on DioException catch (e, s) {
          log('Failed to auth', name: 'AuthRepositoryImpl', error: e, stackTrace: s);

          return Failure<Unit>(DataException('Erro ao realizar o login'));
        }
      case Failure<String>(:final error):
        log('Failed to sign in', name: 'AuthRepositoryImpl', error: error);

        return Failure<Unit>(DataException('Erro ao realizar o login com o Google'));
    }
  }

  @override
  Future<Result<Unit>> signOut() async {
    final result = await _googleSigninService.signOut();

    switch (result) {
      case Success<Unit>():
        final removeResult = await _localStorageService.removeIdToken();

        switch (removeResult) {
          case Success<Unit>():
            return succesOfUnit();
          case Failure<Unit>(:final error):
            log('Failed to remove id token', name: 'AuthRepositoryImpl', error: error);

            return Failure<Unit>(error);
        }

      case Failure<Unit>(:final error):
        log('Failed to sign out', name: 'AuthRepositoryImpl', error: error);

        return Failure<Unit>(error);
    }
  }
}
