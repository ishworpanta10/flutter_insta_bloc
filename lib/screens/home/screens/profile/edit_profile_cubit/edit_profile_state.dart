part of 'edit_profile_cubit.dart';

//ignore: must_be_immutable
class EditProfileState extends Equatable {
  File profileImage;
  String username;
  String bio;
  EditProfileStatus status;
  Failure failure;

  @override
  List<Object> get props => [profileImage, username, bio, status, failure];

  factory EditProfileState.initial() {
    return EditProfileState(
      profileImage: null,
      username: '',
      bio: '',
      status: EditProfileStatus.initial,
      failure: Failure(),
    );
  }

  EditProfileState({
    @required this.profileImage,
    @required this.username,
    @required this.bio,
    @required this.status,
    @required this.failure,
  });

  EditProfileState copyWith({
    File profileImage,
    String username,
    String bio,
    EditProfileStatus status,
    Failure failure,
  }) {
    return EditProfileState(
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}

enum EditProfileStatus { initial, submitting, success, error }
