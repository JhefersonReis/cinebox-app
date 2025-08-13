import 'package:cinebox/config/env.dart';
import 'package:cinebox/core/result/result.dart';
import 'package:cinebox/data/service/services_providers.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backend_rest_client_provider.g.dart';

@Riverpod(keepAlive: true)
Dio backendRestClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.backendBaseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ),
  );

  dio.options.headers['Content-Type'] = 'application/json';
  dio.interceptors.addAll([
    BackendAuthInterceptor(ref: ref),
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  ]);

  return dio;
}

class BackendAuthInterceptor extends Interceptor {
  final Ref ref;

  BackendAuthInterceptor({required this.ref});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final localStorage = ref.read(localStorageServiceProvider);
    final idToken = await localStorage.getIdToken();

    if (idToken case Success(:final value)) {
      options.headers['Authorization'] = 'Bearer $value';
    }

    handler.next(options);
  }
}
