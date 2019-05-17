import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workshop/presentation/main/MainPage.dart';

void main() {
  configureSystemUi();

  runApp(
    MaterialApp(
      home: MainPage(GlobalKey<MainPageState>()),
    ),
  );
}

void configureSystemUi() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}
