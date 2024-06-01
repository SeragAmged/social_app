import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/comments/comment_card.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key, required this.postId});
  final String postId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getPostComments(postId: postId),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: ListView.builder(
              itemCount: AppCubit.get(context).comments.length,
              itemBuilder: (context, index) => CommentCard(
                comment: AppCubit.get(context).comments[index],
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }
}
