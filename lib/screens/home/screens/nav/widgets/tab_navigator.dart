import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/blocs/blocs.dart';
import 'package:flutter_insta_clone/config/custom_router.dart';
import 'package:flutter_insta_clone/cubit/like_cubit/like_post_cubit.dart';
import 'package:flutter_insta_clone/enums/navbar_items.dart';
import 'package:flutter_insta_clone/repositories/repositories.dart';
import 'package:flutter_insta_clone/screens/home/screens/create_post/create_post_cubit/create_post_cubit.dart';
import 'package:flutter_insta_clone/screens/home/screens/feed/feed_bloc/feed_bloc.dart';
import 'package:flutter_insta_clone/screens/home/screens/search/search_cubit/search_cubit.dart';

import '../../screens.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = "/";

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({Key key, this.navigatorKey, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          initialRoute: tabNavigatorRoot,
          onGenerateInitialRoutes: (_, initialRoute) {
            return [
              MaterialPageRoute(
                settings: RouteSettings(name: tabNavigatorRoot),
                builder: (context) => routeBuilders[initialRoute](context),
              ),
            ];
          },
          onGenerateRoute: CustomRoute.onGenerateNestedRoute,
        ),
        onWillPop: () async => false);
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return BlocProvider(
          create: (context) => FeedBloc(
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
            likePostCubit: context.read<LikePostCubit>(),
          )..add(FeedFetchPostsEvent()),
          child: FeedScreen(),
        );

      case BottomNavItem.search:
        return BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(
            userRepo: context.read<UserRepo>(),
          ),
          child: SearchScreen(),
        );

      case BottomNavItem.create:
        return BlocProvider<CreatePostCubit>(
          create: (context) => CreatePostCubit(
            authBloc: context.read<AuthBloc>(),
            postRepository: context.read<PostRepository>(),
            storageRepo: context.read<StorageRepo>(),
          ),
          child: CreatePostScreen(),
        );

      case BottomNavItem.notification:
        return BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(
            notificationRepo: context.read<NotificationRepo>(),
            authBloc: context.read<AuthBloc>(),
          ),
          child: NotificationScreen(),
        );

      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            userRepo: context.read<UserRepo>(),
            authBloc: context.read<AuthBloc>(),
            postRepository: context.read<PostRepository>(),
            likePostCubit: context.read<LikePostCubit>(),
          )..add(
              ProfileLoadEvent(
                userId: context.read<AuthBloc>().state.user.uid,
              ),
            ),
          child: ProfileScreen(),
        );

      default:
        return Scaffold();
    }
  }
}
