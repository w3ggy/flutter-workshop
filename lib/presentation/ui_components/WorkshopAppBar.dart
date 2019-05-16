import 'package:flutter/material.dart';
import 'package:flutter_workshop/resources/ColorRes.dart';

class WorkshopAppBar extends StatelessWidget {
  final Widget titleWidget;

  const WorkshopAppBar({@required this.titleWidget, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(98),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorRes.midnight, ColorRes.darkIndigo],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Center(child: titleWidget),
        ),
      ),
    );
  }
}
