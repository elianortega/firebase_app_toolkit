part of 'user_profile_bloc.dart';

enum UserProfileStatus {
  initial,
  userUpdated,
}

class UserProfileState extends Equatable {
  const UserProfileState({
    required this.status,
    required this.user,
  });

  const UserProfileState.initial()
      : this(
          status: UserProfileStatus.initial,
          user: User.anonymous,
        );

  final UserProfileStatus status;
  final User user;

  @override
  List<Object?> get props => [status, user];

  UserProfileState copyWith({
    UserProfileStatus? status,
    User? user,
  }) =>
      UserProfileState(
        status: status ?? this.status,
        user: user ?? this.user,
      );
}
