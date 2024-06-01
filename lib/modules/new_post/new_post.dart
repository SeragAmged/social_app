import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/styles/icon_broken.dart';

class NewPost extends StatelessWidget {
  const NewPost({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController postController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {
        if (state is AppAddPostSuccessState) {
          Navigator.pop(context);
          AppCubit.get(context).removePostImage();
          postController.text = "";
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add post"),
            leading: IconButton(
              icon: const Icon(IconBroken.arrowLeft_2),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).addPost(
                      text: postController.text,
                      image: AppCubit.get(context).postImage,
                    );
                  }
                },
                child: const Text(
                  "POST",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      if (state is AppUploadPostImageLoadingState ||
                          state is AppAddPostLoadingState)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(
                            minHeight: 10,
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ListTile(
                        leading: FittedBox(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              AppCubit.get(context).userModel!.image,
                            ),
                            radius: 65,
                          ),
                        ),
                        title: Text(AppCubit.get(context).userModel!.name),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              controller: postController,
                              validator: (value) {
                                if (value!.isEmpty &&
                                    AppCubit.get(context).postImage == null) {
                                  return "Add Text or Image";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: "What's in your mind?",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (AppCubit.get(context).postImage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.file(
                                  File(AppCubit.get(context).postImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    AppCubit.get(context).removePostImage(),
                                icon: const Icon(
                                  IconBroken.closeSquare,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: const ButtonStyle(
                                overlayColor:
                                    MaterialStatePropertyAll(Colors.grey),
                              ),
                              onPressed: () {
                                AppCubit.get(context).pickImage(ImageType.post);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    IconBroken.image,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "add Photo",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              style: const ButtonStyle(
                                  overlayColor:
                                      MaterialStatePropertyAll(Colors.grey)),
                              onPressed: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "# Tags",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
