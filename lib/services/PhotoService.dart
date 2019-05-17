import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_workshop/models/NewPost.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class PhotoService {
  static final instanse = PhotoService._();

  final _storage = FirebaseStorage();
  final _uuid = Uuid();

  PhotoService._();

  Future<void> createNewPost(NewPost post) {
    return Firestore.instance
        .collection('posts')
        .add(post.toJson())
        .then((ref) {
      print('here!');
    });
  }

  UploadPhotoTask uploadPhoto(File photo) {
    final fileName = _uuid.v4() + '.' + extension(photo.path);
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
