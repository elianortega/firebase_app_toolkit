import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required NotificationsRepository notificationsRepository,
  })  : _notificationsRepository = notificationsRepository,
        super(const OnboardingInitial()) {
    on<EnableNotificationsRequested>(_onEnableNotificationsRequested);
  }

  final NotificationsRepository _notificationsRepository;

  Future<void> _onEnableNotificationsRequested(
    EnableNotificationsRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(const EnablingNotifications());
      await _notificationsRepository.toggleNotifications(enable: true);
      emit(const EnablingNotificationsSucceeded());
    } catch (error, stackTrace) {
      emit(const EnablingNotificationsFailed());
      addError(error, stackTrace);
    }
  }
}
