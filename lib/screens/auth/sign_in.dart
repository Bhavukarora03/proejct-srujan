
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srujan/components/button.dart';
import 'package:srujan/components/global_snack_bar.dart';
import 'package:srujan/screens/home/home.dart';
import 'package:srujan/services/auth/repositery/auth_repositery.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final navigator = Navigator.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle(context);

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      print(errorModel.error!);
      GlobalSnackBar.show(
        context,
        message: errorModel.error!,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 0, systemOverlayStyle: SystemUiOverlayStyle.dark),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    height: 500,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 16),
                  Button(
                      onPressed: () {
                        signInWithGoogle(ref, context);
                      },
                      variant: 'filled',
                      label: 'Sign In'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Button(
                          onPressed: () {
                            print('Sign Up');
                          },
                          variant: 'text',
                          label: 'Sign Up'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
