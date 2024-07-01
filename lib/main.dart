import 'package:firebase_ml/camera.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Firebase Machine Learning',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const CameraScreen());
  }
}
