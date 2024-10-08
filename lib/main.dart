import 'package:flutter/material.dart';
import 'Mapa/telamapa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela SEMOB',
      theme: ThemeData(
        useMaterial3: true,
      ),
        debugShowCheckedModeBanner: false,
        home: TelaMapa(),
    );
  }
}