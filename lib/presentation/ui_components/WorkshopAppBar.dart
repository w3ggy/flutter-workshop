import 'package:flutter/material.dart';
import 'package:flutter_workshop/resources/ColorRes.dart';

class WorkshopAppBar extends StatelessWidget implements PreferredSize {
  final Widget titleWidget;

  const WorkshopAppBar({@required this.titleWidget, Key key}) : super(key: key);

  @override
  Widget get child => _AppBarContent(titleWidget: titleWidget);

  @override
  Size get preferredSize => Size.fromHeight(64);

  @override
  Widget build(BuildContext context) => child;
}

class _AppBarContent extends StatelessWidget {
  const _AppBarContent({
    Key key,
    @required this.titleWidget,
  }) : super(key: key);

  final Widget titleWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
