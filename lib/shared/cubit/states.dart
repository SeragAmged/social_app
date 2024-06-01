sealed class AppStates {}

class AppInitialState extends AppStates {}

//Get Data
class AppGetDataLoadingState extends AppStates {}

class AppGetDataSuccessState extends AppStates {}

class AppGetDataErrorState extends AppStates {
  final String error;
  AppGetDataErrorState({required this.error});
}

//Email Verification
class AppEmailVerificationLoadingState extends AppStates {}

class AppEmailVerificationSuccessState extends AppStates {}

class AppEmailVerificationErrorState extends AppStates {
  final String error;
  AppEmailVerificationErrorState({required this.error});
}

//Email Update Verification
class AppUpdateEmailVerificationLoadingState extends AppStates {}

class AppUpdateEmailVerificationSuccessState extends AppStates {}

class AppUpdateEmailVerificationDidNotSuccessState extends AppStates {}

class AppUpdateEmailVerificationErrorState extends AppStates {
  final String error;
  AppUpdateEmailVerificationErrorState({required this.error});
}

class AppChangeBottomNavState extends AppStates {}

class AppChangeModeState extends AppStates {}

//SelectProfileImage
class AppSelectProfileImageSuccessState extends AppStates {}

class AppSelectProfileImageErrorState extends AppStates {}

//SelectBannerImage
class AppSelectBannerImageSuccessState extends AppStates {}

class AppSelectBannerImageErrorState extends AppStates {}

//SelectPostImage
class AppSelectPostImageSuccessState extends AppStates {}

class AppSelectPostImageErrorState extends AppStates {}

//UploadProfileImage
class AppUploadProfileImageLoadingState extends AppStates {}

class AppUploadProfileImageSuccessState extends AppStates {}

class AppUploadProfileImageErrorState extends AppStates {}

//UploadBannerImage
class AppUploadBannerImageLoadingState extends AppStates {}

class AppUploadBannerImageSuccessState extends AppStates {}

class AppUploadBannerImageErrorState extends AppStates {}

//UploadPostImage
class AppUploadPostImageLoadingState extends AppStates {}

class AppUploadPostImageSuccessState extends AppStates {}

class AppUploadPostImageErrorState extends AppStates {}

//remove PostImage
class AppPostImageRemoveState extends AppStates {}

//Update Profile
class AppUpdateProfileLoadingsState extends AppStates {}

class AppUpdateProfileSuccessState extends AppStates {}

class AppUpdateProfileErrorState extends AppStates {}

//Add Post
class AppAddPostLoadingState extends AppStates {}

class AppAddPostSuccessState extends AppStates {}

class AppAddPostErrorState extends AppStates {}

//Get Posts
class AppGetPostsLoadingState extends AppStates {}

class AppGetPostsSuccessState extends AppStates {}

class AppGetPostsErrorState extends AppStates {}

class FeedInitialState extends AppStates {}

class ChangeFABVisibility extends AppStates {}

//Get userPost
class AppGetUserByIdLoadingState extends AppStates {}

class AppGetUserByIdSuccessState extends AppStates {}

class AppGetUserByIdErrorState extends AppStates {}

//Like post
class AppLikePostLoadingState extends AppStates {}

class AppLikePostSuccessState extends AppStates {}

class AppLikePostErrorState extends AppStates {}

//UnLike post

class AppUnLikePostLoadingState extends AppStates {}

class AppUnLikePostSuccessState extends AppStates {}

class AppUnLikePostErrorState extends AppStates {}

//Comment post

class AppCommentPostLoadingState extends AppStates {}

class AppCommentPostSuccessState extends AppStates {}

class AppCommentPostErrorState extends AppStates {}

//GetComment post
class AppGetPostCommentsLoadingState extends AppStates {}

class AppGetPostCommentsSuccessState extends AppStates {}

class AppGetPostCommentsErrorState extends AppStates {}

//GetComment post
class AppGetAllUsersLoadingState extends AppStates {}

class AppGetAllUsersSuccessState extends AppStates {}

class AppGetAllUsersErrorState extends AppStates {}


//AppSendMessage
class AppSendMessageLoadingState extends AppStates {}

class AppSendMessageSuccessState extends AppStates {}

class AppSendMessageErrorState extends AppStates {}
