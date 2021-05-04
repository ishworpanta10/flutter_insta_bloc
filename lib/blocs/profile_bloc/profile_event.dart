part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileLoadEvent extends ProfileEvent {
  final String userId;

  ProfileLoadEvent({this.userId});
  @override
  List<Object> get props => [userId];
}
