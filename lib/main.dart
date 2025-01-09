import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const HizAsistani());
}

class HizAsistani extends StatelessWidget {
  const HizAsistani({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
