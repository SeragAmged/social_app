import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/shared/components/functions.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final AppCubit appCubit = AppCubit.get(context);
        return ListView.separated(
          itemCount: appCubit.allUsers.length,
          separatorBuilder: (context, index) => const Divider(
            height: 20,
            endIndent: 8,
            indent: 8,
            color: Colors.grey,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                navigateTo(context, ChatScreen(user: appCubit.allUsers[index]));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        appCubit.allUsers[index].image,
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
                                appCubit.allUsers[index].name,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
