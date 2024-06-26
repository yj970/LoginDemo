import 'package:flutter/material.dart';
import 'package:logindemo/routers/PhoneLoginRouter.dart';
import 'package:logindemo/routers/WebRouter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        'mainRouter': (context) => PhoneLoginRouter(),
        'webRouter': (context) => WebRouter(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: 'mainRouter',
    );
  }
}
