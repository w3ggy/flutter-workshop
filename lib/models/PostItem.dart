class PostItem {
  final String profileName;
  final String avatarUrl;
  final String imageUrl;
  final bool liked;
  final int likeCount;

  PostItem({
    this.profileName,
    this.avatarUrl,
    this.imageUrl,
    this.liked,
    this.likeCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PostItem &&
              runtimeType == other.runtimeType &&
              profileName == other.profileName &&
              avatarUrl == other.avatarUrl &&
              imageUrl == other.imageUrl &&
              liked == other.liked &&
              likeCount == other.likeCount;

  @override
  int get hashCode =>
      profileName.hashCode ^
      avatarUrl.hashCode ^
      imageUrl.hashCode ^
      liked.hashCode ^
      likeCount.hashCode;

  PostItem copy({
    profileName,
    avatarUrl,
    imageUrl,
    liked,
    likeCount,
  }) {
    return PostItem(
      profileName: profileName ?? this.profileName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      liked: liked ?? this.liked,
      likeCount: likeCount ?? this.likeCount,
    );
  }
}
