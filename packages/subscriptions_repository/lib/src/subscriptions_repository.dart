import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

/// {@template subscriptions_failure}
/// A base failure for the subscriptions repository failures.
/// {@endtemplate}
abstract class SubscriptionsFailure with EquatableMixin implements Exception {
  /// {@macro subscriptions_failure}
  const SubscriptionsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template request_subscription_plan_failure}
/// Thrown when requesting a subscription plan fails.
/// {@endtemplate}
class RequestSubscriptionPlanFailure extends SubscriptionsFailure {
  /// {@macro request_subscription_plan_failure}
  const RequestSubscriptionPlanFailure(super.error);
}

/// The subscription plan of a user.
enum SubscriptionPlan {
  /// No subscription plan.
  none,

  /// Premium subscription plan.
  premium
}

/// {@template subscriptions_repository}
/// A repository that manages user subscriptions.
/// {@endtemplate}
class SubscriptionsRepository {
  /// {@macro subscriptions_repository}
  SubscriptionsRepository()
      : _currentSubscriptionPlanSubject =
            BehaviorSubject.seeded(SubscriptionPlan.none);

  final BehaviorSubject<SubscriptionPlan> _currentSubscriptionPlanSubject;

  /// A stream of the current subscription plan of a user.
  Stream<SubscriptionPlan> get currentSubscriptionPlan =>
      _currentSubscriptionPlanSubject;

  /// Requests to set the current subscription plan to [plan].
  Future<void> requestSubscriptionPlan(SubscriptionPlan plan) async {
    _currentSubscriptionPlanSubject.add(plan);
  }
}