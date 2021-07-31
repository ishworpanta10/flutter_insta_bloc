import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/screens/home/screens/profile/profile_screen.dart';
import 'package:flutter_insta_clone/screens/home/screens/search/search_cubit/search_cubit.dart';
import 'package:flutter_insta_clone/widgets/centered_text.dart';
import 'package:flutter_insta_clone/widgets/user_profile_image.dart';

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
                return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
