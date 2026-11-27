// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart' as flutter;
import 'package:material_ui/material_ui.dart'
    hide ThemeData, Colors, ColorScheme, Color, WidgetsFlutterBinding;
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'get_observer_add.dart';
import 'modules/splash_screen/splash_view.dart';
import 'network_helper.dart';
import 'service.dart';

Future<void> main() async {
  flutter.WidgetsFlutterBinding.ensureInitialized();
  await initAuthSessionFromPrefs();

  setupDio();
  NetworkHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Naked Syrups',

      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        flutter.DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US')],

      navigatorObservers: [GlobalRouteObserver()],
      builder: (context, child) {
        child = ResponsiveBreakpoints.builder(
          child: child ?? const SizedBox.shrink(),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
        return child;
      },
      theme: flutter.ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: flutter.Colors.white,
        colorScheme: flutter.ColorScheme.fromSeed(
          seedColor: const flutter.Color(0xFF542E91),
        ),
        fontFamily: 'Euclid Circular B',
      ),
      initialRoute: '/splash',
      getPages: [GetPage(name: '/splash', page: () => SplashScreen())],
    );
  }
}
