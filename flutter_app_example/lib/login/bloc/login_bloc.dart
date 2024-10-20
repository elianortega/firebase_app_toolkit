import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginGoogleSubmitted>(_onGoogleSubmitted);
    on<LoginAppleSubmitted>(_onAppleSubmitted);
    on<LoginTwitterSubmitted>(_onTwitterSubmitted);
    on<LoginFacebookSubmitted>(_onFacebookSubmitted);
  }

  final UserRepository _userRepository;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        valid: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        valid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.valid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _userRepository.logInWithEmailAndPassword(
          email: state.email.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (error, stackTrace) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
        addError(error, stackTrace);
      }
    }
  }

  Future<void> _onGoogleSubmitted(
    LoginGoogleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleCanceled {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onAppleSubmitted(
    LoginAppleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithApple();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onTwitterSubmitted(
    LoginTwitterSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithTwitter();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithTwitterCanceled {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onFacebookSubmitted(
    LoginFacebookSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithFacebook();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithFacebookCanceled {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}
