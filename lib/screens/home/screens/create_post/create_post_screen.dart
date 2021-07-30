import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_insta_clone/helpers/helpers.dart';
import 'package:flutter_insta_clone/screens/home/screens/create_post/create_post_cubit/create_post_cubit.dart';
import 'package:flutter_insta_clone/widgets/error_dialog.dart';
import 'package:flutter_insta_clone/widgets/loading_dialog.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Create Post"),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, createPostState) {
            if (createPostState.status == CreatePostStatus.success) {
              Navigator.of(context, rootNavigator: true).pop();
              _formKey.currentState.reset();
              context.read<CreatePostCubit>().reset();

              BotToast.showText(text: "Post Created Successfully");
            } else if (createPostState.status == CreatePostStatus.submitting) {
              showDialog(
                context: context,
                builder: (context) => LoadingDialog(
                  loadingMessage: 'Creating Post',
                ),
              );
            } else if (createPostState.status == CreatePostStatus.failure) {
              Navigator.of(context, rootNavigator: true).pop();
              BotToast.showText(text: createPostState.failure.message);

              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  message: createPostState.failure.message,
                ),
              );
            }
          },
          builder: (context, createPostState) {
            return SingleChildScrollView(
              child: GestureDetector(
                onTap: () => _selectPostImage(context),
                child: Column(
                  children: [
                    if (createPostState.status == CreatePostStatus.submitting) LinearProgressIndicator(),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: createPostState.postImage != null
                          ? Container(
                              child: Image.file(
                                createPostState.postImage,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 120,
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(hintText: "caption"),
                              onChanged: (value) {
                                context.read<CreatePostCubit>().captionChanged(value);
                              },
                              validator: (value) {
                                return value.trim().isEmpty ? 'Caption cannot be empty' : null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 1.0,
                              ),
                              onPressed: () => _submitForm(
                                context,
                                createPostState.postImage,
                                createPostState.status == CreatePostStatus.submitting,
                              ),
                              child: Text(
                                'Create Post',
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectPostImage(BuildContext context) async {
    // context.read<CreatePostCubit>().postImageChanged(file);
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.rectangle,
      title: 'Post Image',
    );
    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, File postImage, bool isSubmitting) async {
    if (_formKey.currentState.validate() && postImage != null && !isSubmitting) {
      context.read<CreatePostCubit>().submit();
    }
  }
}
