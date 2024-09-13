import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_providers/authentication_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> inject() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<AuthenticationProvider>(
          () => AuthenticationProvider(sf: sharedPreferences));

  sl<AuthenticationProvider>().startService();

}