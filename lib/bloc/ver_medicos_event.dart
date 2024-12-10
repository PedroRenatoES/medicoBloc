abstract class VerMedicosEvent {}

class FetchMedicosEvent extends VerMedicosEvent {
  final int? especialidadId;

  FetchMedicosEvent({this.especialidadId});
}
