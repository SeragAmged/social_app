import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/chats/chat_screen.dart';

import 'states.dart';
import '../../models/user_model.dart';
import '../../modules/chats/chats_screen.dart';
import '../../modules/feeds/feeds_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../modules/users/users_screen.dart';
import '../../shared/components/variables.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/network/remote/firebase_constants.dart';

enum ImageType {
  profile,
  banner,
  post,
}

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = ThemeMode.system == ThemeMode.light ? false : true;
  void changeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.setData(key: 'isDark', value: isDark).then(
        (value) {
          emit(AppChangeModeState());
        },
      );
    }
  }

  final List<Widget> screens = const [
    FeedsScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  final List<String> titles = const [
    "T h e  W a l l",
    "C h a t s",
    "U s e r s",
    "S e t t i n g s"
  ];
  int currentBottomNavIndex = 0;
  void changBottomNavIndex(int index) {
    currentBottomNavIndex = index;
    emit(AppChangeBottomNavState());
  }

  bool fabViability = true;
  void changeFabViability(bool f) {
    fabViability = f;
    emit(ChangeFABVisibility());
  }

  UserModel? userModel;
  void getUserData() {
    if (uId.isNotEmpty) {
      emit(AppGetDataLoadingState());
      FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(uId)
          .get()
          .then(
        (value) {
          userModel = UserModel.fromJson(value.data() ?? {});
          emit(AppGetDataSuccessState());
        },
      ).catchError(
        (error) {
          emit(AppGetDataErrorState(error: error.toString()));
        },
      );
    }
  }

  void sendEmailVerification() {
    emit(AppEmailVerificationLoadingState());
    FirebaseAuth.instance.currentUser!
        .sendEmailVerification()
        .then((value) => emit(AppEmailVerificationSuccessState()))
        .catchError((error) =>
            emit(AppEmailVerificationErrorState(error: error.toString())));
  }

  void updateEmailVerification() {
    emit(AppUpdateEmailVerificationLoadingState());
    if (true /* FirebaseAuth.instance.currentUser!.emailVerified */) {
      FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(uId)
          .update(Map.of({userCollectionIsEmailVerified: true}))
          .then((value) => emit(AppUpdateEmailVerificationSuccessState()))
          .catchError((error) => emit(
              AppUpdateEmailVerificationErrorState(error: error.toString())));
      // ignore: dead_code
    } else {
      emit(AppUpdateEmailVerificationDidNotSuccessState());
    }
  }

  XFile? profileImage;
  XFile? bannerImage;
  XFile? postImage;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageType imageType) async {
    try {
      XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        switch (imageType) {
          case ImageType.profile:
            profileImage = pickedImage;
            emit(AppSelectProfileImageSuccessState());
            break;
          case ImageType.banner:
            bannerImage = pickedImage;
            emit(AppSelectBannerImageSuccessState());
            break;
          case ImageType.post:
            postImage = pickedImage;
            emit(AppSelectPostImageSuccessState());
            break;
        }
      } else {
        _emitSelectErrorState(imageType);
      }
    } catch (e) {
      _emitSelectErrorState(imageType);
    }
  }

  Future<String?> uploadImage({
    required XFile image,
    required String fireStoragePath,
    required ImageType imageType,
  }) async {
    _emitUploadLoadingState(imageType);
    try {
      final value = await FirebaseStorage.instance
          .ref()
          .child("$fireStoragePath/${Uri.file(image.path).pathSegments.last}")
          .putFile(File(image.path));

      final String downloadURL = await value.ref.getDownloadURL();

      _emitUploadSuccessState(imageType);

      return downloadURL;
    } catch (error) {
      _emitUploadErrorState(imageType);
      return null;
    }
  }

  void updateProfile({
    required String name,
    required String bio,
  }) async {
    emit(AppUpdateProfileLoadingsState());
    emit(AppUpdateProfileLoadingsState());

    Map<String, dynamic> newModel = {
      userCollectionName: name,
      userCollectionBio: bio,
    };

    if (profileImage != null) {
      final profileURL = await uploadImage(
        image: profileImage!,
        fireStoragePath: "users/$uId/profile_images",
        imageType: ImageType.profile,
      );
      if (profileURL != null) {
        newModel[userCollectionImage] = profileURL;
      }
    }

    if (bannerImage != null) {
      final bannerURL = await uploadImage(
        image: bannerImage!,
        fireStoragePath: "users/$uId/banner_images",
        imageType: ImageType.banner,
      );
      if (bannerURL != null) {
        newModel[userCollectionBanner] = bannerURL;
      }
    }
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(uId)
        .update(newModel)
        .then((value) {
      emit(AppUpdateProfileSuccessState());

      getUserData();
    }).catchError((onError) {
      emit(AppUpdateProfileErrorState());
    });
  }

  void addPost({String? text, XFile? image}) async {
    String? postImageUrl = image != null
        ? await uploadImage(
            image: image,
            fireStoragePath: 'posts_images',
            imageType: ImageType.post,
          )
        : null;

    var post = PostModel(
      uId: uId,
      name: userModel!.name,
      image: userModel!.image,
      dateTime: DateTime.now().toString(),
      text: text,
      postImage: postImageUrl,
    );

    try {
      emit(AppAddPostLoadingState());
      // final value =
      await FirebaseFirestore.instance
          .collection(postsCollection)
          .add(post.toMap());

      // await value.update({"postId": value.id});
      getPosts();
      emit(AppAddPostSuccessState());
    } catch (error) {
      emit(AppAddPostErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(AppPostImageRemoveState());
  }

  List<PostModel> posts = [];
  List<int> likesCount = [];
  List<int> commentsCount = [];
  List<bool> myLikes = [];

  Future<void> getPosts() async {
    posts = [];
    likesCount = [];
    myLikes = [];
    commentsCount = [];
    emit(AppGetPostsLoadingState());
    final value = await FirebaseFirestore.instance
        .collection(postsCollection)
        .orderBy(userCollectionDatetime, descending: true)
        .get();

    for (int i = 0; i < value.docs.length; i++) {
      var post = value.docs[i];
      PostModel postModel = PostModel.fromJson(post.data());
      final UserModel owner = await getUserById(postModel.uId);
      postModel.postId = post.id;
      postModel.image = owner.image;
      postModel.name = owner.name;

      final likesRef =
          await post.reference.collection(postsCollectionLikes).get();

      final myLike =
          await post.reference.collection(postsCollectionLikes).doc(uId).get();

      final commentsRef = await post.reference.collection("comments").get();
      post.reference.collection("comments").snapshots().listen((event) {
        likesCount[i] = event.docs.length;
      });

      post.reference
          .collection(postsCollectionLikes)
          .snapshots()
          .listen((event) {
        likesCount[i] = event.docs.length;
      });

      post.reference
          .collection(postsCollectionLikes)
          .doc(uId)
          .snapshots()
          .listen((event) => myLikes[i] =
              event.data() == null ? false : event.data()!["like"]);

      myLikes.add(myLike.data() == null ? false : myLike.data()!["like"]);
      likesCount.add(likesRef.docs.length);
      commentsCount.add(commentsRef.docs.length);
      posts.add(postModel);
      emit(AppGetPostsSuccessState());
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      final value = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(id)
          .get();

      return UserModel.fromJson(value.data()!);
    } catch (e) {
      rethrow;
    }
  }

  void likePost(String postId) async {
    emit(AppLikePostLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection(postsCollection)
          .doc(postId)
          .collection("likes")
          .doc(uId)
          .set({"like": true});
      emit(AppLikePostSuccessState());
    } catch (e) {
      emit(AppLikePostErrorState());
      rethrow;
    }
  }

  void unLikePost(String postId) async {
    emit(AppUnLikePostLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection(postsCollection)
          .doc(postId)
          .collection("likes")
          .doc(uId)
          .delete();

      emit(AppUnLikePostSuccessState());
    } catch (e) {
      emit(AppUnLikePostErrorState());
      rethrow;
    }
  }

  void commentPost({required String postId, required String comment}) async {
    emit(AppCommentPostLoadingState());
    try {
      final CommentModel commentModel = CommentModel(
        uId: uId,
        comment: comment,
        dateTime: DateTime.now().toString(),
        image: userModel?.image ?? "",
        name: userModel?.name ?? "",
      );
      await FirebaseFirestore.instance
          .collection(postsCollection)
          .doc(postId)
          .collection("comments")
          .add(commentModel.toMap());
      emit(AppCommentPostSuccessState());
    } catch (e) {
      emit(AppCommentPostErrorState());
      rethrow;
    }
  }

  List<CommentModel> comments = [];
  void getPostComments({required String postId}) async {
    comments = [];
    emit(AppGetPostCommentsLoadingState());
    try {
      final value = await FirebaseFirestore.instance
          .collection(postsCollection)
          .doc(postId)
          .collection("comments")
          .get();
      for (var comment in value.docs) {
        final CommentModel cCommentModel =
            CommentModel.fromJson(comment.data());
        final UserModel owner = await getUserById(cCommentModel.uId);
        cCommentModel.image = owner.image;
        cCommentModel.name = owner.name;
        comments.add(cCommentModel);
        log('cCommentModel: ${cCommentModel.comment}');
      }

      emit(AppGetPostCommentsSuccessState());
    } catch (getPostCommentsError) {
      log('getPostCommentsError: $getPostCommentsError');
      emit(AppGetPostCommentsErrorState());
    }
  }

  List<UserModel> allUsers = [];

  void getUsers() async {
    if (allUsers.isEmpty) {
      emit(AppGetAllUsersLoadingState());
      try {
        final value =
            await FirebaseFirestore.instance.collection(usersCollection).get();
        for (var user in value.docs) {
          if (UserModel.fromJson(user.data()).uId != uId) {
            allUsers.add(UserModel.fromJson(user.data()));
          }
        }

        emit(AppGetAllUsersSuccessState());
      } catch (error) {
        emit(AppGetAllUsersErrorState());
      }
    }
  }

  void sendMessage(MessageModel message) async {
    emit(AppSendMessageLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(uId)
          .collection("chats")
          .doc(message.receiverId)
          .collection("message")
          .add(message.toMap());

      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(message.receiverId)
          .collection("chats")
          .doc(uId)
          .collection("message")
          .add(message.toMap());
      emit(AppSendMessageSuccessState());
    } catch (e) {
      emit(AppSendMessageErrorState());
    }
  }

  List<MessageModel> messages = [];
  void getMessages(String receiverId) {
    emit(AppSendMessageLoadingState());
    try {
      FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(uId)
          .collection("chats")
          .doc(receiverId)
          .collection("message")
          .orderBy("datetime")
          .snapshots()
          .listen((event) {
        messages = [];
        for (var message in event.docs) {
          messages.add(MessageModel.fromJson(message.data()));
          ChatScreen.scrollController.jumpTo(
            ChatScreen.scrollController.position.maxScrollExtent + 50,
          );
          emit(AppSendMessageSuccessState());
        }
      });
    } catch (e) {
      emit(AppSendMessageErrorState());
    }
  }

  void _emitSelectErrorState(ImageType imageType) {
    switch (imageType) {
      case ImageType.profile:
        emit(AppSelectProfileImageErrorState());
        break;
      case ImageType.banner:
        emit(AppSelectBannerImageErrorState());
        break;
      case ImageType.post:
        emit(AppSelectPostImageErrorState());
        break;
    }
  }

  void _emitUploadLoadingState(ImageType imageType) {
    switch (imageType) {
      case ImageType.profile:
        emit(AppUploadProfileImageLoadingState());
        break;
      case ImageType.banner:
        emit(AppUploadBannerImageLoadingState());
        break;
      case ImageType.post:
        emit(AppUploadPostImageLoadingState());
        break;
    }
  }

  void _emitUploadSuccessState(ImageType imageType) {
    switch (imageType) {
      case ImageType.profile:
        emit(AppUploadProfileImageSuccessState());
        break;
      case ImageType.banner:
        emit(AppUploadBannerImageSuccessState());
        break;
      case ImageType.post:
        emit(AppUploadPostImageSuccessState());
        break;
    }
  }

  void _emitUploadErrorState(ImageType imageType) {
    switch (imageType) {
      case ImageType.profile:
        emit(AppUploadProfileImageErrorState());
        break;
      case ImageType.banner:
        emit(AppUploadBannerImageErrorState());
        break;
      case ImageType.post:
        emit(AppUploadPostImageErrorState());
        break;
    }
  }
}
