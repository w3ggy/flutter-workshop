import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_workshop/models/NewPost.dart';

class PhotoService {
  static final instanse = PhotoService._();

  PhotoService._();

  Future<void> createNewPost(NewPost post) {
    return Firestore.instance
        .collection('posts')
        .add(post.toJson())
        .then((ref) {
      print('here!');
    });
  }
}
