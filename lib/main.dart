import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_app/screen/Splash/splash_screen.dart';
import 'package:story_app/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Instagram-Like Stories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purpleAccent,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
          GetPage(
          name: '/home',
          page: () => HomeScreen(),
        ),
      ],
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const NotFoundScreen(),
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: const Center(
        child: Text(
          '404 - Page Not Found',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
