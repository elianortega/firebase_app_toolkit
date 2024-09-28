part of 'app_bloc.dart';

enum AppStatus {
  authenticated(),
  unauthenticated();

  bool get isLoggedIn => this == AppStatus.authenticated;
}

class AppState extends Equatable {
  const AppState({
    required this.status,
    this.user = User.anonymous,
    this.showLoginOverlay = false,
  });

  const AppState.authenticated(
    User user,
  ) : this(
          status: AppStatus.authenticated,
          user: user,
        );

  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final bool showLoginOverlay;

  bool get isAuthenticated => status == AppStatus.authenticated;

  AppState copyWith({
    AppStatus? status,
    User? user,
    bool? showLoginOverlay,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      showLoginOverlay: showLoginOverlay ?? this.showLoginOverlay,
    );
  }

  @override
  List<Object> get props => [
        status,
        user,
        showLoginOverlay,
      ];
}
