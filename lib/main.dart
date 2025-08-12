import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'get_observer_add.dart';
import 'modules/splash_screen/splash_view.dart';
import 'service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDio();
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
      navigatorObservers: [GlobalRouteObserver()],
      builder: (context, child) {
        child = ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
        return child;
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Euclid Circular B',
      ),
      home: const SizedBox(),
      initialRoute: '/splash',
      getPages: [GetPage(name: '/splash', page: () => SplashScreen())],
    );
  }
}
