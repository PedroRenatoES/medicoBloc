import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'historial_medico_event.dart';
import 'historial_medico_state.dart';

class HistorialMedicoBloc extends Bloc<HistorialMedicoEvent, HistorialMedicoState> {
  HistorialMedicoBloc() : super(HistorialMedicoInitial()) {
    on<FetchHistorialMedicoEvent>(_onFetchHistorialMedico);
  }

  Future<void> _onFetchHistorialMedico(
    FetchHistorialMedicoEvent event,
    Emitter<HistorialMedicoState> emit,
  ) async {
    emit(HistorialMedicoLoading());
    
    try {
      final response = await http.get(
        Uri.parse("https://4a43-189-28-68-207.ngrok-free.app/HistorialMedico/${event.pacienteId}"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey("\$values")) {
          emit(HistorialMedicoLoaded(jsonResponse["\$values"]));
        } else {
          emit(HistorialMedicoError('Error: La clave "\$values" no existe en la respuesta.'));
        }
      } else {
        emit(HistorialMedicoError('Error: Código de estado HTTP ${response.statusCode}'));
      }
    } catch (e) {
      emit(HistorialMedicoError('Error al obtener el historial médico: $e'));
    }
  }
}
