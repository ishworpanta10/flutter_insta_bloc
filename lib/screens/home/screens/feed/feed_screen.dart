import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/screens/home/screens/feed/feed_bloc/feed_bloc.dart';
import 'package:flutter_insta_clone/widgets/widgets.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, feedState) {
        if (feedState.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(message: feedState.failure.message),
          );
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
          child: ListView.builder(
            itemCount: feedState.postList.length,
            itemBuilder: (context, index) {
              final post = feedState.postList[index];
              return PostView(
                postModel: post,
                isLiked: true,
              );
            },
          ),
        );
    }
  }
}
