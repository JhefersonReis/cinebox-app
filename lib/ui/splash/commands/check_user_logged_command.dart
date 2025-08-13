import 'package:cinebox/core/result/result.dart';
import 'package:cinebox/data/repositories/repositories_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_user_logged_command.g.dart';

@riverpod
class CheckUserLoggedCommand extends _$CheckUserLoggedCommand {
  @override
  Future<bool?> build() async => null;

  void execute() async {
    state = AsyncLoading();

    final authRepository = ref.read(authRepositoryProvider);

    final isLoggedResult = await authRepository.isLogged();

    state = switch (isLoggedResult) {
      Success<bool>(value: final isLogged) => AsyncData(isLogged),
      Failure<bool>(:final error) => AsyncError(error, StackTrace.current),
    };
  }
}
