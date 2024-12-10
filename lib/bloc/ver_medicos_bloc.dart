import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ver_medicos_event.dart';
import 'ver_medicos_state.dart';

class VerMedicosBloc extends Bloc<VerMedicosEvent, VerMedicosState> {
  VerMedicosBloc() : super(VerMedicosInitial()) {
    on<FetchMedicosEvent>(_onFetchMedicos);
  }

  Future<void> _onFetchMedicos(
    FetchMedicosEvent event,
    Emitter<VerMedicosState> emit,
  ) async {
    emit(VerMedicosLoading());
    
    try {
      final url = event.especialidadId != null 
        ? "https://95bb-189-28-68-207.ngrok-free.app/api/Medicos?especialidadId=${event.especialidadId}"
        : "https://95bb-189-28-68-207.ngrok-free.app/api/Medicos";
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        emit(VerMedicosLoaded(jsonResponse['\$values']));
      } else {
        emit(VerMedicosError('Error en la respuesta del servidor'));
      }
    } catch (e) {
      emit(VerMedicosError('Error al obtener los médicos: $e'));
    }
  }
}
