import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workshop/presentation/feed/FeedPage.dart';

void main() {
  configureSystemUi();

  runApp(
    MaterialApp(
      home: FeedPage(),
    ),
  );
}

void configureSystemUi() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}
