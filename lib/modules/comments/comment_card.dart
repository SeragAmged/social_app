import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment, required this.index});
  final CommentModel comment;
  final int index;
  @override
  Widget build(BuildContext context) {
    // List<CommentModel> comments = AppCubit.get(context).comments;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Card(
          color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
          elevation: 5,
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        comment.image,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment.name,
                                style: const TextStyle(
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 15,
                              ),
                            ],
                          ),
                          Text(
                            comment.dateTime.substring(0, 10),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(height: 1.3),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 20,
                  endIndent: 8,
                  indent: 8,
                  color: Colors.grey,
                ),
                //Post text
                SelectableText(
                  comment.comment,
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                // post hashtags
              ],
            ),
          ),
        );
      },
    );
  }
}
