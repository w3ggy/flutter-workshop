import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_workshop/models/NewPost.dart';
import 'package:flutter_workshop/models/PostItem.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class PhotoService {
  static final instanse = PhotoService._();

  final _storage = FirebaseStorage();
  final _uuid = Uuid();
  final _random = Random();

  PhotoService._();

  Future<void> createNewPost(NewPost post) {
    return Firestore.instance
        .collection('posts')
        .add(post.toJson())
        .then((ref) {
      print('here!');
    });
  }

  Stream<List<PostItem>> getPhotoFeedPosts() {
    return Firestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((documents) => documents.documents.map((doc) {
              return PostItem(
                avatarUrl:
                    'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/01E3C2AE-8E06-48E8-A3CA-644729649CDE.png',
                imageUrl: doc.data['imageUrl'],
                profileName: 'annileras',
                liked: _random.nextInt(100) % 2 == 0,
                likeCount: _random.nextInt(250),
              );
            }).toList());
  }

  UploadPhotoTask uploadPhoto(File photo) {
    final fileName = _uuid.v4() + extension(photo.path);
    final StorageReference ref = _storage.ref().child('photos').child(fileName);
    final StorageUploadTask uploadTask = ref.putFile(photo);

    uploadTask.events.listen((event) {
      print(event);
    });

    return UploadPhotoTask(
      task: uploadTask,
      fileName: fileName,
    );
  }
}

class UploadPhotoTask {
  final StorageUploadTask task;
  final String fileName;

  UploadPhotoTask({
    @required this.task,
    @required this.fileName,
  });
}
