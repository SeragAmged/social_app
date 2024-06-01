import 'package:social_app/shared/network/remote/firebase_constants.dart';

class MessageModel {
  late final String uId;
  String? message;
  late final String receiverId;
  late final String dateTime;

  MessageModel({
    this.message,
    required this.uId,
    required this.receiverId,
    required this.dateTime,
  });

  MessageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    uId = json[userCollectionId];
    receiverId = json["receiverId"];
    dateTime = json[userCollectionDatetime];
    message = json["message"];
  }
  Map<String, dynamic> toMap() => {
        userCollectionId: uId,
        "receiverId": receiverId,
        userCollectionDatetime: dateTime,
        "message": message,
      };
}
