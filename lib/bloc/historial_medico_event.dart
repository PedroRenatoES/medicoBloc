abstract class HistorialMedicoEvent {}

class FetchHistorialMedicoEvent extends HistorialMedicoEvent {
  final int pacienteId;

  FetchHistorialMedicoEvent(this.pacienteId);
}
