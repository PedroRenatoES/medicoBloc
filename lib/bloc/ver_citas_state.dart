abstract class VerCitasState {}

class VerCitasInitial extends VerCitasState {}

class VerCitasLoading extends VerCitasState {}

class VerCitasLoaded extends VerCitasState {
  final List<dynamic> citas;

  VerCitasLoaded(this.citas);
}

class VerCitasError extends VerCitasState {
  final String mensaje;

  VerCitasError(this.mensaje);
}
