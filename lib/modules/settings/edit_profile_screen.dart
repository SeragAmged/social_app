import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/styles/icon_broken.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController bioController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    AppCubit cubit = AppCubit.get(context);
    UserModel? model = cubit.userModel;
    nameController.text = model?.name ?? "";
    bioController.text = model?.bio ?? "";
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // AppCubit cubit = AppCubit.get(context);
        // UserModel? model = cubit.userModel;
        // nameController.text = model?.name ?? "";
        // bioController.text = model?.bio ?? "";
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(IconBroken.arrowLeft_2),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text("E d  i t  p r o f i l e"),
            actions: [
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).updateProfile(
                      name: nameController.text,
                      bio: bioController.text,
                    );
                  }
                },
                child: Text(
                  "Update",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.greenAccent),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state is AppUpdateProfileLoadingsState ||
                      state is AppUploadBannerImageLoadingState ||
                      state is AppUploadProfileImageLoadingState)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  SizedBox(
                    height: 190,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: cubit.bannerImage == null
                                    ? Image(
                                        image:
                                            NetworkImage(model?.banner ?? ""),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(cubit.bannerImage!.path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: !AppCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black,
                                  child: IconButton(
                                    onPressed: () =>
                                        cubit.pickImage(ImageType.banner),
                                    icon: Icon(
                                      IconBroken.image,
                                      color: AppCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 65,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                backgroundImage: cubit.profileImage == null
                                    ? NetworkImage(model?.image ?? "")
                                    : FileImage(File(cubit.profileImage!.path))
                                        as ImageProvider<Object>,
                                radius: 60,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: !AppCubit.get(context).isDark
                                  ? Colors.white
                                  : Colors.black,
                              child: IconButton(
                                onPressed: () =>
                                    cubit.pickImage(ImageType.profile),
                                icon: Icon(
                                  IconBroken.camera,
                                  color: AppCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    model?.name ?? "",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    model?.bio ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  cubit.isDark
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    IconBroken.edit,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: bioController,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    IconBroken.edit,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Form(
                          key: formKey,
                          child: Column(
                            children: [
                              defaultTextFormField(
                                controller: nameController,
                                hint: 'Name',
                                type: TextInputType.name,
                                suffix: IconBroken.edit,
                              ),
                              const SizedBox(height: 5),
                              defaultTextFormField(
                                controller: bioController,
                                hint: 'Bio',
                                type: TextInputType.name,
                                suffix: IconBroken.edit,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
