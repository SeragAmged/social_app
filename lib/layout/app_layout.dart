import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/email_verification_notification.dart';
import 'package:social_app/shared/components/variables.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/functions.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/styles/icon_broken.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return (firstLogin.isEmpty)
        ? MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AppCubit()
                  ..changeMode(
                      fromShared: CacheHelper.getData(key: "isDark") ?? false)
                  ..getUserData()
                  ..getPosts()
                  ..getUsers(),
              )
            ],
            child: const Consumer(),
          )
        : const Consumer();
  }
}

class Consumer extends StatelessWidget {
  const Consumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppEmailVerificationSuccessState) {
          toast(
            context: context,
            message: "Chick your mail",
            state: ToastState.success,
          );
        }
        if (state is AppEmailVerificationErrorState) {
          toast(
            context: context,
            message: state.error,
            state: ToastState.error,
          );
        }
        if (state is AppUpdateEmailVerificationDidNotSuccessState) {
          toast(
            context: context,
            message: "Wait !",
            state: ToastState.warning,
          );
        }
        if (state is AppUpdateEmailVerificationSuccessState) {
          toast(
            context: context,
            message: "Email verified",
            state: ToastState.success,
          );
        }
      },
      builder: (context, state) {
        final AppCubit cubit = AppCubit.get(context);
        bool isEmailVerified = cubit.userModel?.isEmailVerified ?? false;
        // bool isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified??false;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(cubit.titles[cubit.currentBottomNavIndex]),
            actions:
                cubit.screens[cubit.currentBottomNavIndex] is SettingsScreen
                    ? [
                        IconButton(
                          onPressed: () => cubit.changeMode(),
                          icon: const Icon(Icons.dark_mode_outlined),
                        ),
                        IconButton(
                          onPressed: () => logOut(context),
                          icon: const Icon(Icons.logout),
                        ),
                      ]
                    : [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(IconBroken.notification),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(IconBroken.search),
                        ),
                      ],
          ),
          body: SafeArea(
            child: ConditionalBuilder(
              condition: cubit.userModel == null ||
                  state is AppUpdateEmailVerificationLoadingState ||
                  state is AppGetDataLoadingState,
              builder: (context) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
              fallback: (context) => ConditionalBuilder(
                condition: !isEmailVerified,
                builder: (context) =>
                    EmailVerificationNotification(appCubit: cubit),
                fallback: (context) =>
                    cubit.screens[cubit.currentBottomNavIndex],
              ),
            ),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
                // topLeft: Radius.circular(20.0),
                // topRight: Radius.circular(20.0),
                ),
            child: BottomNavigationBar(
              selectedFontSize: 0,
              unselectedFontSize: 0,
              // iconSize: 30,
              onTap: (index) {
                cubit.changBottomNavIndex(index);
              },
              currentIndex: cubit.currentBottomNavIndex,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(IconBroken.home),
                  label: cubit.titles[cubit.currentBottomNavIndex],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(IconBroken.chat),
                  label: cubit.titles[cubit.currentBottomNavIndex],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(IconBroken.user),
                  label: cubit.titles[cubit.currentBottomNavIndex],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(
                    IconBroken.setting,
                  ),
                  label: cubit.titles[cubit.currentBottomNavIndex],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
