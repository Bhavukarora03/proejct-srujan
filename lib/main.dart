import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:routemaster/routemaster.dart';
import 'package:srujan/services/auth/models/error_model.dart' as models;
import 'package:srujan/services/auth/repositery/auth_repositery.dart';
import 'package:srujan/services/navigation/navigation.dart';
import 'package:srujan/services/routes/router.dart';
import 'package:srujan/theme/themes.dart';

void main() async {
  await dotenv.load();
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<NavigationService>(NavigationService());

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  models.ErrorModel? error;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    error = await ref.read(authRepositoryProvider).getUserData();
    if (error!.error == null && error!.data != null) {
      ref.read(userProvider.notifier).update((state) => error!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          final user = ref.watch(userProvider);
          if (user != null && user.token.isNotEmpty) {
            return loggedInRoute;
          } else {
            return loggedOutRoute;
          }
        },
      ),
    );
  }
}
