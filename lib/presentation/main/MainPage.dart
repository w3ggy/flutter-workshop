import 'package:flutter/material.dart';
import 'package:flutter_workshop/presentation/camera/CameraPage.dart';
import 'package:flutter_workshop/presentation/feed/FeedPage.dart';
import 'package:flutter_workshop/presentation/profile/ProfilePage.dart';
import 'package:flutter_workshop/widgets/FooterWidget.dart';

class MainPage extends StatefulWidget {
  MainPage(Key key) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  var currentIndex = 0;

  List<RenderFunction> get renderPage => [
    () => FeedPage(),
    () => CameraPage(widget.key),
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

  void openFeedPage() {
    setState(() {
      currentIndex = 0;
    });
  }
}

typedef RenderFunction = Widget Function();
