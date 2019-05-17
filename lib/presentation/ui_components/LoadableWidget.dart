import 'package:flutter/material.dart';

class LoadableWidget extends StatelessWidget {
  final Widget child;
  final bool loading;

  LoadableWidget({
    @required this.child,
    @required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
            child: GestureDetector(
          child: Visibility(
            visible: loading,
            child: Container(
              color: const Color(0x99000000),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
        ))
      ],
    );
  }
}
