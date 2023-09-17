part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  String? error;
  LoginFailure({required this.error});
}
