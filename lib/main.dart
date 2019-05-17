import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workshop/presentation/root/RootPage.dart';
import 'package:flutter_workshop/services/Authentication.dart';

void main() {
  configureSystemUi();

  runApp(
    MaterialApp(
      home: RootPage(auth: Auth()),
    ),
  );
}

void configureSystemUi() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}
