abstract class VerCitasEvent {}

class FetchCitasEvent extends VerCitasEvent {

  final int pacienteId;

  FetchCitasEvent({required this.pacienteId});  // Definiendo el pacienteId

  @override
  List<Object?> get props => [pacienteId];

}
