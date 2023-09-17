part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}
class RegisterSuccess extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterFailure extends RegisterState {
  String? error;
  RegisterFailure({required this.error});
}