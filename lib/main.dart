import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:srujan/screens/auth/sign_in.dart';
import 'package:srujan/services/navigation/navigation.dart';
import 'package:srujan/theme/themes.dart';

void main() async {
  await dotenv.load();
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<NavigationService>(NavigationService());

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyAppTheme.lightTheme, // Use the light theme
      darkTheme: MyAppTheme.darkTheme,
      navigatorKey: GetIt.instance<NavigationService>()
          .navigatorKey, // Use the dark theme
      home: const SignInPage(),
    );
  }
}
