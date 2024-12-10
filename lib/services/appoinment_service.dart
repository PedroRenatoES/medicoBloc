import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentService {
  static const String _baseUrl = "https://95bb-189-28-68-207.ngrok-free.app/api/Citas";

  Future<bool> scheduleAppointment({
    required int pacienteId,
    int? idMedico,
    DateTime? fechaHora,
    required String motivo,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/agendar"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "IdPaciente": pacienteId,
        "IdMedico": idMedico,
        "FechaHora": fechaHora?.toIso8601String(),
        "Motivo": motivo,
        "Estado": "Agendada",
      }),
    );

    return response.statusCode == 200;
  }
}
