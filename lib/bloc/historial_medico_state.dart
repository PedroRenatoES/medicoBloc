abstract class HistorialMedicoState {}

class HistorialMedicoInitial extends HistorialMedicoState {}

class HistorialMedicoLoading extends HistorialMedicoState {}

class HistorialMedicoLoaded extends HistorialMedicoState {
  final List<dynamic> historial;

  HistorialMedicoLoaded(this.historial);
}

class HistorialMedicoError extends HistorialMedicoState {
  final String mensaje;

  HistorialMedicoError(this.mensaje);
}
