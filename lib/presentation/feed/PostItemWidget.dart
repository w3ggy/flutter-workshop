import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_workshop/models/NewPost.dart';
import 'package:flutter_workshop/models/PostItem.dart';
import 'package:flutter_workshop/resources/ColorRes.dart';
import 'package:flutter_workshop/resources/ImageRes.dart';
import 'package:flutter_workshop/services/PhotoServive.dart';

class PostItemWidget extends StatefulWidget {
  PostItem data;

  PostItemWidget({@required this.data, Key key}) : super(key: key);

  @override
  _PostItemWidgetState createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends State<PostItemWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(animationController);
  }

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
            _onLikeClicked(item, true);
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
              ),
              ScaleTransition(
                scale: animation,
                child: Opacity(
                  opacity: animation.value,
                  child: Icon(
                    Icons.favorite,
                    color: ColorRes.white,
                    size: likeSize,
                  ),
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

  void _onLikeClicked(PostItem item, bool liked) {
    final likeCount = liked ? item.likeCount + 1 : item.likeCount - 1;
    final updatedItem = item.copy(liked: liked, likeCount: likeCount);

    if (liked) {
      animation.addListener(() {
        updateWidget(updatedItem);
      });

      animationController.reset();
      animationController.forward();

      animation.removeListener(() {
        updateWidget(updatedItem);
      });
    } else {
      updateWidget(updatedItem);
    }

    Firestore.instance
        .collection('books')
        .document()
        .setData({'title': 'title', 'author': 'author'});

    PhotoService.instanse.createNewPost(NewPost(
      imageUrl:
      'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/A663BE71-D3DD-4C62-AAE0-64198C457A86.png',
      userId: '8126r93hbsdlkf8fakljd',
      createdAt: DateTime.now().toIso8601String(),
    ));
  }

  void updateWidget(PostItem newData) {
    setState(() {
      widget.data = newData;
    });
  }
}
