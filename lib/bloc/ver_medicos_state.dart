abstract class VerMedicosState {}

class VerMedicosInitial extends VerMedicosState {}

class VerMedicosLoading extends VerMedicosState {}

class VerMedicosLoaded extends VerMedicosState {
  final List<dynamic> medicos;

  VerMedicosLoaded(this.medicos);
}

class VerMedicosError extends VerMedicosState {
  final String mensaje;

  VerMedicosError(this.mensaje);
}
