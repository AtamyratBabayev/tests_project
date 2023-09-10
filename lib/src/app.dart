import 'package:flutter/material.dart';
import 'package:tests_project/src/features/features.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: const ScrollWithTabsScreen(),
    );
  }
}
