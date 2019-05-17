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

  @override
  void initState() {
    super.initState();
    items.addAll(_getMockItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHeader(context),
      body: buildBody(),
    );
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
            itemBuilder: (context, i) => buildListItem(context, items[i]),
            separatorBuilder: (context, i) => buildDivider(),
          ),
        ),
      ],
    );
  }

  List<PostItem> _getMockItems() {
    return [
      PostItem(
        profileName: 'annileras',
        avatarUrl:
        'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/01E3C2AE-8E06-48E8-A3CA-644729649CDE.png',
        imageUrl:
        'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/A663BE71-D3DD-4C62-AAE0-64198C457A86.png',
        liked: true,
        likeCount: 128,
      ),
      PostItem(
        profileName: 'alexschmit',
        avatarUrl:
        'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/01E3C2AE-8E06-48E8-A3CA-644729649CDE.png',
        imageUrl:
        'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/A663BE71-D3DD-4C62-AAE0-64198C457A86.png',
        liked: false,
        likeCount: 109,
      ),
    ];
  }

  Widget buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 6),
      color: ColorRes.darkIndigo5,
    );
  }

  Widget buildListItem(BuildContext context, PostItem item) {
    return PostItemWidget(data: item);
  }
}
