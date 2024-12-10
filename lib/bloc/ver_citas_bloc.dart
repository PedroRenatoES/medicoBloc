import 'package:flutter_bloc/flutter_bloc.dart';
import 'ver_citas_event.dart';
import 'ver_citas_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerCitasBloc extends Bloc<VerCitasEvent, VerCitasState> {
  VerCitasBloc() : super(VerCitasInitial()) {
    on<FetchCitasEvent>(_onFetchCitas);
  }

  Future<void> _onFetchCitas(
    FetchCitasEvent event,
    Emitter<VerCitasState> emit,
  ) async {
    emit(VerCitasLoading());
    
    try {
      final response = await http.get(
        Uri.parse("https://4a43-189-28-68-207.ngrok-free.app/api/Citas/ver/${event.pacienteId}"),
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> citasData = jsonResponse['\$values'];
        emit(VerCitasLoaded(citasData));
      } else {
        emit(VerCitasError('Error al cargar las citas'));
      }
    } catch (e) {
      emit(VerCitasError('Error de conexión'));
    }
  }
}

