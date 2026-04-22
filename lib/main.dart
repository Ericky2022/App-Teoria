import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MusicTheoryApp());
}

class MusicTheoryApp extends StatelessWidget {
  const MusicTheoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teoria Musical',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005F73),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const HomePage(),
    );
  }
}
