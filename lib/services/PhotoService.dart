import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_workshop/models/NewPost.dart';
import 'package:flutter_workshop/models/PostItem.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class PhotoService {
  static final instanse = PhotoService._();

  final _storage = FirebaseStorage();
  final _uuid = Uuid();
  final _random = Random();

  PhotoService._();

  Future<void> createNewPost(NewPost post) {
    //TODO: implement logic
    return Future.value();
  }

  Stream<List<PostItem>> getPhotoFeedPosts() {
    //TODO: implement logic
    final ele = _getMockItems();
    return Stream.fromIterable(ele);
  }

  //TODO: remove after Firebase integration.
  Iterable<List<PostItem>> _getMockItems() {
    return [
      [
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
      ]
    ];
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
