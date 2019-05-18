import 'package:flutter/material.dart';
import 'package:flutter_workshop/models/PostItem.dart';

class PostItemWidget extends StatefulWidget {
  PostItem data;

  PostItemWidget({@required this.data, Key key}) : super(key: key);

  @override
  _PostItemWidgetState createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends State<PostItemWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildItemHeader(widget.data),
        buildItemImage(widget.data),
        buildItemFooter(widget.data),
      ],
    );
  }

  Widget buildItemHeader(PostItem item) {
    //TODO: implement item header
    return Container(
      height: 50,
      color: Colors.yellow,
    );
  }

  Widget buildItemImage(PostItem item) {
    //TODO: implement item body

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: Colors.green,
      ),
    );
  }

  Widget buildItemFooter(PostItem item) {
    return Container(
      height: 50,
      color: Colors.blue,
    );
  }
}
