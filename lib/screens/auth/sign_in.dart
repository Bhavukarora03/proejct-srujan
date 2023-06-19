import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:routemaster/routemaster.dart';
import 'package:srujan/components/button.dart';
import 'package:srujan/screens/auth/sign_up.dart';
import 'package:srujan/services/auth/repositery/auth_repositery.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    var logger = Logger();
    final navigator = Routemaster.of(context);
    final errorModel = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace('/');
    } else {
      logger.e(errorModel.error);
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                ListView(
                  children: [
                    AppBar(toolbarHeight: 0, systemOverlayStyle: SystemUiOverlayStyle.dark),
                    const SizedBox(height: kToolbarHeight), // Add spacing for the app bar
                    const SizedBox(height: 16),
                    // Add other content here
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  onPressed: () => signInWithGoogle(ref, context),
                  variant: 'filled',
                  label: 'Sign In',
                ),
                const SizedBox(height: 16),
                Button(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
                  },
                  variant: 'filled',
                  label: 'Sign Up',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
