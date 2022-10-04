import 'dart:ffi';
import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'App.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arvid Test App',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        // textTheme: GoogleFonts.latoTextTheme(),
        fontFamily: 'Comic',
      ),
      darkTheme: ThemeData(
        cardColor: Colors.blue,
        brightness: Brightness.dark,
        accentColor: Colors.red,
        backgroundColor: Colors.red,
        hoverColor: Colors.white,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black45,
        ),
        // textTheme: GoogleFonts.latoTextTheme(),
        fontFamily: 'Comic',
      ),
      home: const TestApp(),
    );
  }
}


