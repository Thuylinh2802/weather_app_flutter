import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/weatherProvider.dart';
import 'Screen/homePage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: MaterialApp(
        title: 'Weather App',
        home: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        // remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        home: HomePage(),
      );
  }
}