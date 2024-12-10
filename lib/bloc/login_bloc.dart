import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc(this.authService) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final result = await authService.login(event.email, event.password);
        if (result != null) {
          emit(LoginSuccess(result['pacienteId']));
        } else {
          emit(LoginFailure('Credenciales incorrectas'));
        }
      } catch (e) {
        emit(LoginFailure('Error en el servidor: $e'));
      }
    });
  }
}
