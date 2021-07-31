import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/blocs/blocs.dart';
import 'package:flutter_insta_clone/repositories/repositories.dart';
import 'package:flutter_insta_clone/widgets/widgets.dart';

import 'widgets/profile_stats.dart';
import 'widgets/widgets.dart';

class ProfileScreenArgs {
  final String userId;
  ProfileScreenArgs({@required this.userId});
}

class ProfileScreen extends StatefulWidget {
  //for routing
  static const String routeName = "/profile";

  static Route route({@required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: ProfileScreen.routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepo: context.read<UserRepo>(),
          authBloc: context.read<AuthBloc>(),
          postRepository: context.read<PostRepository>(),
        )..add(ProfileLoadEvent(userId: args.userId)),
        child: ProfileScreen(),
      ),
    );
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  final tabList = [
    Tab(icon: Icon(Icons.grid_on, size: 28)),
    Tab(icon: Icon(Icons.list, size: 28)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabList.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, profileState) {
        if (profileState.status == ProfileStatus.failure) {
          //closing the existing dialog if exits during loading
          Navigator.of(context, rootNavigator: true).pop();

          BotToast.closeAllLoading();
          BotToast.showText(text: profileState.failure.message);
          //showing the error dialog if error exists
          showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                title: "Error signing in",
                message: profileState.failure.message,
              );
            },
          );
        }
      },
      builder: (context, profileState) {
        return _buildBody(profileState);
      },
    );
  }

  Widget _buildBody(ProfileState profileState) {
    switch (profileState.status) {
      case ProfileStatus.loading:
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text(profileState.userModel.username),
            centerTitle: true,
            actions: [
              if (profileState.isCurrentUser)
                IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          AuthLogOutRequestedEvent(),
                        );
                  },
                  icon: Icon(Icons.exit_to_app),
                )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().add(ProfileLoadEvent(userId: profileState.userModel.id));
              await Future.delayed(
                Duration(milliseconds: 500),
              );
              return true; //true return will remove refresh indicator go away
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            UserProfileImage(
                              radius: 40,
                              profileImageURl: profileState.userModel.imageUrl,
                            ),
                            ProfileStat(
                              isCurrentUser: profileState.isCurrentUser,
                              isFollowing: profileState.isFollowing,
                              posts: profileState.posts.length,
                              followers: profileState.userModel.followers,
                              following: profileState.userModel.following,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: ProfileInfo(
                            username: profileState.userModel.username,
                            bio: profileState.userModel.bio,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: tabList,
                    indicatorWeight: 3,
                    onTap: (index) {
                      context.read<ProfileBloc>().add(
                            ProfileToggleGridViewEvent(isGridView: index == 0),
                          );
                    },
                  ),
                ),
                profileState.isGridView
                    ? SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final post = profileState.posts[index];
                            return GestureDetector(
                              onTap: () {},
                              child: CachedNetworkImage(
                                imageUrl: post.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          childCount: profileState.posts.length,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final post = profileState.posts[index];
                            return PostView(
                              postModel: post,
                              isLiked: true,
                            );
                          },
                          childCount: profileState.posts.length,
                        ),
                      ),
              ],
            ),
          ),
        );
    }
  }
}
