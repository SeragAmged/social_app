import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/settings/edit_profile_screen.dart';
import 'package:social_app/shared/components/functions.dart';
import 'package:social_app/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        UserModel? model = cubit.userModel;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 190,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Image(
                          image: NetworkImage(model?.banner ?? ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 65,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(model?.image ?? ""),
                        radius: 60,
                      ),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "100",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "posts",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "256",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "photos",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "10k",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "followers",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "64",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "followings",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color!),
                      ),
                      child: Text(
                        "Add Photos",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton.icon(
                    onPressed: () => navigateTo(context, const EditScreen()),
                    icon: Icon(
                      IconBroken.edit,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    label: const Text(""),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color:
                              Theme.of(context).textTheme.bodyMedium!.color!),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
