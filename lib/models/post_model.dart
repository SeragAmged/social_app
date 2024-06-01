import 'package:social_app/shared/network/remote/firebase_constants.dart';

class PostModel {
  late final String uId;
  String? postId;
  late String name;
  late String image;
  late final String dateTime;
  late final String? text;
  late final String? postImage;
  

  PostModel({
    required this.uId,
    required this.name,
    required this.image,
    required this.dateTime,
    required this.text,
    required this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uId = json[userCollectionId];
    postId = json[postsCollectionId];
    name = json[userCollectionName];
    image = json[userCollectionImage];
    dateTime = json[userCollectionDatetime];
    text = json[userCollectionText];
    postImage = json[userCollectionPostImage];
  }
  Map<String, dynamic> toMap() => {
        userCollectionId: uId,
        userCollectionName: name,
        userCollectionImage: image,
        userCollectionDatetime: dateTime,
        userCollectionText: text,
        userCollectionPostImage: postImage,
      };
}
