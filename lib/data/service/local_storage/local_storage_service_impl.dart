import 'package:cinebox/core/result/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './local_storage_service.dart';

class LocalStorageServiceImpl implements LocalStorageService {
  final FlutterSecureStorage _flutterSecureStorage;

  LocalStorageServiceImpl({required FlutterSecureStorage flutterSecureStorage})
    : _flutterSecureStorage = flutterSecureStorage;

  static const tokenKey = 'id_token';

  @override
  Future<Result<String>> getIdToken() async {
    final token = await _flutterSecureStorage.read(key: tokenKey);
    if (token != null) {
      return Success(token);
    }
    return Failure(Exception('Token not found'));
  }

  @override
  Future<Result<Unit>> removeIdToken() async {
    await _flutterSecureStorage.delete(key: tokenKey);
    return succesOfUnit();
  }

  @override
  Future<Result<Unit>> saveIdToken(String token) async {
    await _flutterSecureStorage.write(key: tokenKey, value: token);
    return succesOfUnit();
  }
}
