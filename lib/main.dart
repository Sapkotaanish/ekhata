import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home.dart';

void main() {
  runApp(const EkhataApp());
}

class EkhataApp extends StatelessWidget {
  const EkhataApp({super.key});

  static const Map<int, Color> color = {
    50: const Color.fromRGBO(71, 83, 224, 1),
    100: const Color.fromRGBO(71, 83, 224, 1),
    200: const Color.fromRGBO(71, 83, 224, 1),
    300: const Color.fromRGBO(71, 83, 224, 1),
    400: const Color.fromRGBO(71, 83, 224, 1),
    500: const Color.fromRGBO(71, 83, 224, 1),
    600: const Color.fromRGBO(71, 83, 224, 1),
    700: const Color.fromRGBO(71, 83, 224, 1),
    800: const Color.fromRGBO(71, 83, 224, .8),
    900: const Color.fromRGBO(71, 83, 224, .9),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ekhata",
      theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          // textTheme: GoogleFonts.latoTextTheme(
          //   Theme.of(context).textTheme,
          // ),
          // fontFamily: "Lato",
          primarySwatch: MaterialColor(0xff4c57cf, color),
          scaffoldBackgroundColor: Colors.grey[100],
          // textTheme: Theme.of(context).textTheme.apply(
          //       bodyColor: Colors.white,
          //       displayColor: Colors.white,
          //     ),
          inputDecorationTheme: InputDecorationTheme(
              // prefixIconColor: Colors.white,
              // suffixIconColor: Colors.white,
              hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w200, fontSize: 12.0),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
              ),
              border: const OutlineInputBorder(),
              labelStyle: new TextStyle(color: Colors.green),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.solid, color: Colors.green),
              ))),
      home: const Home(),
    );
  }
}
