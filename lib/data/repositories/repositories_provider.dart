import 'package:cinebox/data/repositories/auth/auth_repository.dart';
import 'package:cinebox/data/repositories/auth/auth_repository_impl.dart';
import 'package:cinebox/data/service/services_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repositories_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    localStorageService: ref.read(localStorageServiceProvider),
    googleSigninService: ref.read(googleSignInServiceProvider),
    authService: ref.read(authServiceProvider),
  );
}
