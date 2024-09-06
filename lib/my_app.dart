import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_authentication/app_providers/authentication_provider.dart';

import 'dependency_inject.dart';
import 'views/splash_view.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _authProvider = sl<AuthenticationProvider>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
      ],
      child: MaterialApp(
        title: 'Voice Authentication',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashView(),
      ),
    );
  }
}