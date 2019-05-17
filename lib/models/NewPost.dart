import 'package:meta/meta.dart';

class NewPost {
  final String imageUrl;
  final String userId;
  final String createdAt;

  NewPost({
    @required this.imageUrl,
    @required this.userId,
    @required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}
