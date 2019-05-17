import 'package:flutter/material.dart';
import 'package:flutter_workshop/presentation/camera/CameraPage.dart';
import 'package:flutter_workshop/presentation/feed/FeedPage.dart';
import 'package:flutter_workshop/presentation/profile/ProfilePage.dart';
import 'package:flutter_workshop/widgets/FooterWidget.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var currentIndex = 0;

  final List<RenderFunction> renderPage = [
    () => FeedPage(),
    () => CameraPage(),
    () => ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: renderPage[currentIndex]()),
        FooterWidget(
          selectedIndex: currentIndex,
          onItemSelected: (index) => setState(() => currentIndex = index),
        ),
      ],
    );
  }
}

typedef RenderFunction = Widget Function();
