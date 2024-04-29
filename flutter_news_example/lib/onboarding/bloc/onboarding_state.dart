part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class EnablingNotifications extends OnboardingState {
  const EnablingNotifications();
}

class EnablingNotificationsSucceeded extends OnboardingState
    with AnalyticsEventMixin {
  const EnablingNotificationsSucceeded();

  @override
  AnalyticsEvent get event => PushNotificationSubscriptionEvent();

  @override
  List<Object> get props => [event];
}

class EnablingNotificationsFailed extends OnboardingState {
  const EnablingNotificationsFailed();
}
