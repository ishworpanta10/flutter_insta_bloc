import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/repositories/repositories.dart';
import 'package:flutter_insta_clone/screens/home/screens/profile/profile_screen.dart';
import 'package:flutter_insta_clone/screens/home/screens/search/search_cubit/search_cubit.dart';
import 'package:flutter_insta_clone/widgets/centered_text.dart';
import 'package:flutter_insta_clone/widgets/user_profile_image.dart';
import 'package:flutter_insta_clone/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search User',
              filled: true,
              fillColor: Colors.grey[200],
              border: InputBorder.none,
              suffixIcon: IconButton(
                  onPressed: () {
                    context.read<SearchCubit>().clearSearch();
                    _searchController.clear();
                  },
                  icon: const Icon(Icons.clear)),
            ),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (value) {
              if (value.trim().isNotEmpty) {
                context.read<SearchCubit>().searchUser(query: value.trim());
              }
            },
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, searchState) {
            switch (searchState.status) {
              case SearchStatus.error:
                return CenteredText(text: searchState.failure.message);

              case SearchStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              case SearchStatus.loaded:
                return searchState.userList.isNotEmpty
                    ? ListView.builder(
                        itemCount: searchState.userList.length,
                        itemBuilder: (context, index) {
                          final user = searchState.userList[index];
                          return ListTile(
                            leading: UserProfileImage(radius: 22, profileImageURl: user.imageUrl),
                            title: Text(user.username, style: const TextStyle(fontSize: 16)),
                            onTap: () => Navigator.pushNamed(
                              context,
                              ProfileScreen.routeName,
                              arguments: ProfileScreenArgs(userId: user.id),
                            ),
                          );
                        },
                      )
                    : CenteredText(text: 'no user found');

              default:
                return _buildShowFirebaseUsers();
            }
          },
        ),
      ),
    );
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
