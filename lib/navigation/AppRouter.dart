import 'package:flutter/material.dart';
import 'package:flutter_workshop/presentation/camera/CameraPage.dart';
import 'package:flutter_workshop/presentation/main/MainPage.dart';
import 'package:flutter_workshop/presentation/profile/ProfilePage.dart';

AppRouter appRouter = AppRouter();

class AppRouter {
  void openMainScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false);
  }

  void openProfileScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
        (Route<dynamic> route) => false);
  }

  void openCameraScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CameraPage()),
        (Route<dynamic> route) => false);
  }
}