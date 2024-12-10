import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_medico_api_web_1/bloc/mainScreen_event.dart';
import 'package:flutter_medico_api_web_1/bloc/mainScreen_state.dart';


class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(MainScreenInitial()) {
    on<LogoutRequested>((event, emit) {
      // Aquí podrías agregar lógica adicional, como limpiar tokens de sesión.
      emit(LogoutSuccess());
    });
  }
}
