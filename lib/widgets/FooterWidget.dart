import 'package:flutter/material.dart';
import 'package:flutter_workshop/resources/ColorRes.dart';
import 'package:flutter_workshop/resources/ImageRes.dart';

class FooterWidget extends StatelessWidget {
  final OnItemSelected onItemSelected;
  final int selectedIndex;

  FooterWidget({@required this.onItemSelected, @required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.darkIndigo,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: buildMenuItems(),
        ),
      ),
    );
  }

  List<Widget> buildMenuItems() {
    var menuItems = [
      _MenuItem(
        image: selectedIndex == 0 ? ImageRes.icHomeFilled : ImageRes.icHome,
      ),
      _MenuItem(
        image: ImageRes.icAdd,
        isLargeItem: true,
      ),
      _MenuItem(
        image:
            selectedIndex == 2 ? ImageRes.icProfileFilled : ImageRes.icProfile,
      )
    ];

    return menuItems
        .asMap()
        .map((index, menuItem) => MapEntry(
              index,
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => onItemSelected(index),
                child: menuItem,
              ),
            ))
        .values
        .toList();
  }
}

class _MenuItem extends StatelessWidget {
  final String image;
  final bool isLargeItem;

  const _MenuItem({this.image, this.isLargeItem = false});

  @override
  Widget build(BuildContext context) {
    final double size = isLargeItem ? 28 : 20;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Image.asset(image, width: size, height: size),
    );
  }
}

typedef OnItemSelected = void Function(int index);
