import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/cubit/like_cubit/like_post_cubit.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/repositories/repositories.dart';
import 'package:flutter_insta_clone/screens/home/screens/feed/feed_bloc/feed_bloc.dart';
import 'package:flutter_insta_clone/widgets/widgets.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange && context.read<FeedBloc>().state.status != FeedStatus.paginating) {
          context.read<FeedBloc>().add(FeedPaginatePostsEvent());
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, feedState) {
        if (feedState.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(message: feedState.failure.message),
          );
        } else if (feedState.status == FeedStatus.paginating) {
          BotToast.showText(text: "fetching more posts");
          // BotToast.showLoading();
        }
      },
      builder: (context, feedState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Instagram Clone"),
            actions: [
              if (feedState.postList.isEmpty && feedState.status == FeedStatus.loaded)
                IconButton(
                  onPressed: () => context.read<FeedBloc>().add(FeedFetchPostsEvent()),
                  icon: Icon(
                    Icons.refresh,
                  ),
                ),
            ],
          ),
          body: _buildBody(feedState),
        );
      },
    );
  }

  Widget _buildBody(FeedState feedState) {
    switch (feedState.status) {
      case FeedStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );

      default:
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(
              Duration(milliseconds: 300),
            );
            context.read<FeedBloc>().add(FeedFetchPostsEvent());
            return true;
          },
          child: Column(
            children: [
              _buildShowFirebaseUsers(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: feedState.postList.length,
                  itemBuilder: (context, index) {
                    final post = feedState.postList[index];
                    final likedPostState = context.watch<LikePostCubit>().state;
                    final isLiked = likedPostState.likedPostIds.contains(post.id);
                    final recentlyLiked = likedPostState.recentlyLikedPostsIds.contains(post.id);
                    return PostView(
                      postModel: post,
                      isLiked: isLiked,
                      recentlyLiked: recentlyLiked,
                      onLike: () {
                        if (isLiked) {
                          context.read<LikePostCubit>().unLikePost(postModel: post);
                        } else {
                          context.read<LikePostCubit>().likePost(postModel: post);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildShowFirebaseUsers() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      // color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Suggestions for You',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: const TextStyle(fontSize: 15, color: Colors.blue),
                ),
              )
            ],
          ),
          StreamBuilder<List<UserModel>>(
              stream: UserRepo().getAllFirebaseUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userList = snapshot.data;
                  return Container(
                    height: 160,
                    child: ListView.builder(
                      padding: EdgeInsets.only(right: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: userList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final user = userList[index];
                        return SuggestionTile(user: user);
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}
