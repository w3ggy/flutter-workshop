import 'package:flutter/material.dart';
import 'package:flutter_workshop/models/NewPost.dart';
import 'package:flutter_workshop/models/PostItem.dart';
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
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
      ],
    ).animate(animationController)
      ..addListener(() {
        this.setState(() {});
      });
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

  Widget buildListItem(BuildContext context, PostItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        buildItemHeader(item),
        buildItemImage(item),
        buildItemFooter(item),
      ],
    );
  }

  Widget buildItemHeader(PostItem item) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildAvatar(item),
          buildUserName(item),
        ],
      ),
    );
  }

  Widget buildItemImage(PostItem item) {
    final likeSize = MediaQuery.of(context).size.width / 2;
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: ColorRes.veryLightPink,
        child: GestureDetector(
          onDoubleTap: () {
            animationController.reset();
            animationController.forward();
            _onLikeClicked(item, true);
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
              ),
              Opacity(
                opacity: animation.value,
                child: Icon(
                  Icons.favorite,
                  color: ColorRes.white,
                  size: likeSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItemFooter(PostItem item) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 12, 0, 18),
      child: Row(
        children: <Widget>[
          buildLikeButton(item),
          buildLikeCountLabel(item),
        ],
      ),
    );
  }

  Widget buildAvatar(PostItem item) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(item.avatarUrl),
        ),
        border: Border.all(color: ColorRes.veryLightPink, width: 1),
      ),
    );
  }

  Widget buildUserName(PostItem item) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 0, 2),
      child: Text(
        item.profileName,
        style: TextStyle(color: ColorRes.darkIndigo, fontSize: 13),
      ),
    );
  }

  Widget buildLikeButton(PostItem item) {
    return GestureDetector(
      onTap: () => _onLikeClicked(item, !item.liked),
      child: Image(
        width: 20,
        height: 20,
        image: AssetImage(item.liked ? ImageRes.icLiked : ImageRes.icLike),
      ),
    );
  }

  Widget buildLikeCountLabel(PostItem item) {
    final like = item.likeCount == 1 ? 'like' : 'likes';
    final label = '${item.likeCount} $like';
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Text(
        label,
        style: TextStyle(
          color: ColorRes.darkIndigo,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 6),
      color: ColorRes.darkIndigo5,
    );
  }

  void _onLikeClicked(PostItem item, bool liked) {
    final position = items.indexOf(item);
    final likeCount = liked ? item.likeCount + 1 : item.likeCount - 1;
    final updatedItem = item.copy(liked: liked, likeCount: likeCount);

    setState(() {
      items[position] = updatedItem;
    });

    PhotoService.instanse.createNewPost(NewPost(
      imageUrl:
          'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/A663BE71-D3DD-4C62-AAE0-64198C457A86.png',
      userId: '8126r93hbsdlkf8fakljd',
      createdAt: DateTime.now().toIso8601String(),
    ));
  }
}
