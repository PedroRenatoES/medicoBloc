import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';
import '../services/auth_service.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService authService;

  RegisterBloc(this.authService) : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      try {
        bool success = await authService.register(event.formData);
        if (success) {
          emit(RegisterSuccess());
        } else {
          emit(RegisterFailure('Error en el registro. Intente nuevamente.'));
        }
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}
