import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_medico_api_web_1/bloc/appoinment_state.dart';
import 'package:flutter_medico_api_web_1/services/appoinment_service.dart';
import 'appointment_event.dart';


class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentService appointmentService;

  AppointmentBloc(this.appointmentService) : super(AppointmentInitial()) {
    on<AppointmentSubmitted>(_onAppointmentSubmitted);
  }

  Future<void> _onAppointmentSubmitted(
    AppointmentSubmitted event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(AppointmentLoading());
    
    try {
      final success = await appointmentService.scheduleAppointment(
        pacienteId: event.pacienteId,
        idMedico: event.idMedico,
        fechaHora: event.fechaHora,
        motivo: event.motivo,
      );

      if (success) {
        emit(AppointmentSuccess());
      } else {
        emit(AppointmentFailure('No se pudo agendar la cita.'));
      }
    } catch (e) {
      emit(AppointmentFailure('Error: $e'));
    }
  }
}
