
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/modules/feeds/post_item.dart';
import 'package:social_app/modules/new_post/new_post.dart';
import 'package:social_app/shared/components/functions.dart';
import 'package:social_app/shared/cubit/states.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  late ScrollController _scrollController;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Attach a listener to the ScrollController to handle scrolling events
    _scrollController.addListener(() {
      setState(() {
        // If the user is scrolling down, hide the FAB; if scrolling up, show it
        _isVisible = _scrollController.position.userScrollDirection ==
            ScrollDirection.forward;
      });
    });
  }

  @override
  void dispose() {
    // Dispose the ScrollController to avoid memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => AppCubit.get(context).getPosts(),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: AppCubit.get(context).posts.length,
              itemBuilder: (context, index) => PostItem(
                model: AppCubit.get(context).posts[index],
                index: index,
              ),
            ),
          ),
          floatingActionButton: _isVisible
              ? FloatingActionButton(
                  onPressed: () {
                    navigateTo(context, const NewPost());
                  },
                  child: Icon(
                    Icons.add,
                    color: AppCubit.get(context).isDark
                        ? Colors.black
                        : Colors.white,
                    size: 25,
                  ),
                )
              : null,
        );
      },
    );
  }
}

 /* class FeedsScreen extends StatelessWidget {
  FeedsScreen({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedsCubit, FeedsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (_scrollController.position.userScrollDirection ==
                  ScrollDirection.forward) {
                FeedsCubit.get(context).changeFabViability(true);
              } else if (_scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse) {
                FeedsCubit.get(context).changeFabViability(false);
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) => const PostItem(),
            ),
          ),
          floatingActionButton: FeedsCubit.get(context).fabViability
              ? FloatingActionButton(
                  onPressed: () {
                    navigateTo(context, NewPost());
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 25,
                  ),
                )
              : null,
        );
      },
    );
  }
} */