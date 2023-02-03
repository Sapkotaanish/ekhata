import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(const EkhataApp());
}

class EkhataApp extends StatelessWidget{

  const EkhataApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Ekhata",
      home: const Home(),
    );
  }
}