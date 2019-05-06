import 'package:flutter/material.dart';
import 'package:flutter_workshop/navigation/AppRouter.dart';
import 'package:flutter_workshop/resources/ColorRes.dart';
import 'package:flutter_workshop/resources/ImageRes.dart';

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 40),
      color: ColorRes.darkIndigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () => appRouter.openMainScreen(context),
            child: Image.asset(
              ImageRes.icHomeFilled,
              width: 28,
              height: 28,
            ),
          ),
          GestureDetector(
            onTap: () => appRouter.openCameraScreen(context),
            child: Image.asset(
              ImageRes.icAdd,
              width: 46,
              height: 46,
            ),
          ),
          GestureDetector(
            onTap: () => appRouter.openProfileScreen(context),
            child: Image.asset(
              ImageRes.icProfile,
              width: 28,
              height: 28,
            ),
          ),
        ],
      ),
    );
  }
}