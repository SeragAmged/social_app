import 'package:social_app/shared/network/remote/firebase_constants.dart';

class UserModel {
  late final String uId;
  late final String name;
  late final String email;
  late final String phone;
  late final String image;
  late final String banner;
  late final String bio;
  late  bool isEmailVerified;

  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.banner,
    required this.bio,
    required this.isEmailVerified,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json[userCollectionId];
    name = json[userCollectionName];
    email = json[userCollectionEmail];
    phone = json[userCollectionPhone];
    image = json[userCollectionImage];
    banner = json[userCollectionBanner];
    bio = json[userCollectionBio];
    isEmailVerified = json[userCollectionIsEmailVerified];
  }
  Map<String, dynamic> toMap() => {
        userCollectionName: name,
        userCollectionId: uId,
        userCollectionEmail: email,
        userCollectionPhone: phone,
        userCollectionImage: image,
        userCollectionBanner: banner,
        userCollectionBio: bio,
        userCollectionIsEmailVerified: isEmailVerified,
      };
}
