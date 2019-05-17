import 'package:flutter/material.dart';
import 'package:flutter_workshop/presentation/feed/FeedPage.dart';

AppRouter appRouter = AppRouter();

class AppRouter {
  void openFeedScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => FeedPage()),
      (Route<dynamic> route) => false,
    );
  }
}
