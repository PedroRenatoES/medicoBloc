abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final int pacienteId;

  LoginSuccess(this.pacienteId);
}
class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
