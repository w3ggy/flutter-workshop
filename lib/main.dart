import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workshop/presentation/main/MainPage.dart';

void main() {
  configureSystemUI();

  runApp(
    MaterialApp(
      home: MainPage(GlobalKey<MainPageState>()),
    ),
  );
}

void configureSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}
