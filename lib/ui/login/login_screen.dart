import 'package:cinebox/ui/core/themes/resource.dart';
import 'package:cinebox/ui/core/widgets/loader_messages.dart';
import 'package:cinebox/ui/login/commands/login_with_google_command.dart';
import 'package:cinebox/ui/login/login_view_model.dart';
import 'package:cinebox/ui/login/widgets/sign_in__google_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with LoaderAndMessage {
  @override
  Widget build(BuildContext context) {
    ref.listen(loginWithGoogleCommandProvider, (_, state) {
      state.whenOrNull(
        data: (_) => Navigator.pushReplacementNamed(context, '/home'),
        error: (_, __) => showErrorSnackBar('Erro ao tentar realizar o login'),
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            R.ASSETS_IMAGES_BG_LOGIN_PNG,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            constraints: const BoxConstraints.expand(),
            color: Colors.black.withAlpha(170),
          ),
          Container(
            constraints: const BoxConstraints.expand(),
            padding: EdgeInsets.only(top: 108),
            child: Column(
              spacing: 48,
              children: [
                Image.asset(R.ASSETS_IMAGES_LOGO_PNG),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Consumer(
                    builder: (context, ref, child) => SignInGoogleButton(
                      isLoading: ref.watch(loginWithGoogleCommandProvider).isLoading,
                      onPressed: () {
                        final loginViewModel = ref.read(loginViewModelProvider);

                        loginViewModel.googleLogin();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
