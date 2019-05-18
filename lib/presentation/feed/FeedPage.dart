import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_workshop/models/PostItem.dart';
import 'package:flutter_workshop/presentation/feed/PostItemWidget.dart';
import 'package:flutter_workshop/presentation/ui_components/WorkshopAppBar.dart';
import 'package:flutter_workshop/resources/ColorRes.dart';
import 'package:flutter_workshop/resources/ImageRes.dart';
import 'package:flutter_workshop/services/PhotoService.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  List<PostItem> items = List();
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    subscription = PhotoService.instanse.getPhotoFeedPosts().listen((posts) {
      setState(() {
        items = posts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHeader(context),
      body: buildBody(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  Widget buildHeader(BuildContext context) {
    return WorkshopAppBar(
      titleWidget: Center(
        child: Image.asset(ImageRes.workshop),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Flexible(
          child: ListView.separated(
            padding: EdgeInsets.all(0),
            itemCount: items.length,
            itemBuilder: (context, i) => PostItemWidget(data: items[i]),
            separatorBuilder: (context, i) => buildDivider(),
          ),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 6),
      color: ColorRes.darkIndigo5,
    );
  }
}
