import 'package:social_app/shared/network/remote/firebase_constants.dart';

class CommentModel {
  late final String uId;
  late String name;
  late String image;
  late final String dateTime;
  late final String comment;

  CommentModel({
    required this.uId,
    required this.name,
    required this.image,
    required this.dateTime,
    required this.comment,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    uId = json[userCollectionId];
    name = json[userCollectionName];
    image = json[userCollectionImage];
    dateTime = json[userCollectionDatetime];
    comment = json[userCollectionText];
  }
  Map<String, dynamic> toMap() => {
        userCollectionId: uId,
        userCollectionName: name,
        userCollectionImage: image,
        userCollectionDatetime: dateTime,
        userCollectionText: comment,
      };
}
