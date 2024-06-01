import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comments/comments_screen.dart';
import 'package:social_app/shared/components/functions.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/styles/icon_broken.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.model,
    required this.index,
  });
  final PostModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Card(
          color: AppCubit.get(context).isDark ? Colors.black : Colors.white,
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
                        model.image,
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
                                model.name,
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
                            model.dateTime.substring(0, 10),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(height: 1.3),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_horiz))
                  ],
                ),
                const Divider(
                  height: 20,
                  endIndent: 8,
                  indent: 8,
                  color: Colors.grey,
                ),
                //Post text
                if (model.text != null)
                  SelectableText(
                    model.text!,
                    style: Theme.of(context).textTheme.titleMedium!,
                  ),
                // post hashtags
                Wrap(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "#test_dev",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "#test_dev",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "#test_dev",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "#test_dev",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (model.postImage != null)
                  Container(
                    height: 200.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          model.postImage!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 15),
                //like comment
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        AppCubit.get(context).myLikes[index]
                            ? AppCubit.get(context).unLikePost(model.postId!)
                            : AppCubit.get(context).likePost(model.postId!);
                      },
                      child: Row(
                        children: [
                          AppCubit.get(context).myLikes[index]
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  IconBroken.heart,
                                  color: Colors.red,
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${AppCubit.get(context).likesCount[index]} likes",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          CommentsScreen(postId: model.postId!),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            IconBroken.chat,
                            color: Colors.amber,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${AppCubit.get(context).commentsCount[index]} comments",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  endIndent: 8,
                  indent: 8,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            model.image,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width - 100,
                          child: TextFormField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "write a comment ...",
                            ),
                            cursorColor: Colors.grey,
                            onFieldSubmitted: (value) => AppCubit().commentPost(
                              postId:
                                  AppCubit.get(context).posts[index].postId!,
                              comment: commentController.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
