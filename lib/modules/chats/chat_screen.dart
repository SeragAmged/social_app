import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_message_widget.dart';
import 'package:social_app/shared/components/variables.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/styles/icon_broken.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.user});
  final UserModel user;

  static final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    AppCubit.get(context).getMessages(user.uId);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(IconBroken.arrowLeft_2),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    user.image,
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
                            user.name,
                            style: const TextStyle(
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: AppCubit.get(context).messages.length,
                    itemBuilder: (context, index) {
                      return ChatMessageWidget(
                        message: AppCubit.get(context).messages[index].message!,
                        mine: AppCubit.get(context).messages[index].uId == uId,
                        date: AppCubit.get(context).messages[index].dateTime,
                      );
                    },
                  ),
                ),
                // const ChatMessageWidget(
                //   message: 'Hello World!',
                //   mine: false,
                //   date: '',
                // ),
                // const ChatMessageWidget(
                //   message: 'Hello World!',
                //   mine: true,
                //   date: '',
                // ),
                // // const Spacer(),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type your Message Here ...",
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          child: MaterialButton(
                            minWidth: 1,
                            height: double.infinity,
                            onPressed: () {
                              AppCubit.get(context).sendMessage(
                                MessageModel(
                                  message: messageController.text,
                                  uId: uId,
                                  receiverId: user.uId,
                                  dateTime: DateTime.now().toString(),
                                ),
                              );
                            },
                            child: const Icon(
                              IconBroken.send,
                              color: Colors.white,
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
