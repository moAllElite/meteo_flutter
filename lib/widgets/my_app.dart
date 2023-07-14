import 'package:flutter/material.dart';
import 'package:meteo/widgets/my_color.dart';
import 'package:meteo/widgets/my_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Météo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(inversePrimary: grey),
          useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Météo'),
      debugShowCheckedModeBanner: false,
    );
  }
}