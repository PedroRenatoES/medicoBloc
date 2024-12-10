abstract class AppointmentEvent {}

class AppointmentSubmitted extends AppointmentEvent {
  final int pacienteId;
  final int? idMedico;
  final DateTime? fechaHora;
  final String motivo;

  AppointmentSubmitted({
    required this.pacienteId,
    required this.idMedico,
    required this.fechaHora,
    required this.motivo,
  });
}
