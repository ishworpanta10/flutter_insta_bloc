import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_insta_clone/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_insta_clone/models/failure_model.dart';
import 'package:flutter_insta_clone/models/models.dart';
import 'package:flutter_insta_clone/repositories/post/post_repository.dart';
import 'package:flutter_insta_clone/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final StorageRepo _storageRepo;
  final AuthBloc _authBloc;
  CreatePostCubit({
    @required PostRepository postRepository,
    @required StorageRepo storageRepo,
    @required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _storageRepo = storageRepo,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  void postImageChanged(File file) {
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void captionChanged(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void reset() {
    emit(CreatePostState.initial());
  }

  void submit() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      //we use .empty here because we just want user id for post model
      //auth bloc give use current logged in user id
      final author = UserModel.empty.copyWith(id: _authBloc.state.user.uid);
      // final model = UserModel(id: _authBloc.state.user.uid); /// i think same as above
      // print("Author Model Ref Data $author ");
      final postImageUrl = await _storageRepo.uploadPostImageAndGiveUrl(image: state.postImage);
      final caption = state.caption;
      final post = PostModel(
        caption: caption,
        imageUrl: postImageUrl,
        author: author,
        likes: 0,
        dateTime: DateTime.now(),
      );

      _postRepository.createPost(postModel: post);
      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      // debugPrint("Error during post submit ${err.toString()}");
      emit(
        state.copyWith(
          status: CreatePostStatus.failure,
          failure: const Failure(message: "unable to create your post"),
        ),
      );
    }
  }
}
