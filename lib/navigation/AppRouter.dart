import 'package:flutter/material.dart';
import 'package:flutter_workshop/presentation/main/MainPage.dart';

AppRouter appRouter = AppRouter();

class AppRouter {
  void openMainScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }
}