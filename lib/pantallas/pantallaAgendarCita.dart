import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgendarCitaScreen extends StatefulWidget {
  final int pacienteId;

  AgendarCitaScreen({required this.pacienteId});

  @override
  _AgendarCitaScreenState createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  final _formKey = GlobalKey<FormState>();
  int? idMedico;
  DateTime? fechaHora;
  String motivo = "";

  Future<void> agendarCita() async {
    final response = await http.post(
      Uri.parse("https://4a43-189-28-68-207.ngrok-free.app/api/Citas/agendar"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "IdPaciente": widget.pacienteId,
        "IdMedico": idMedico,
        "FechaHora": fechaHora?.toIso8601String(),
        "Motivo": motivo,
        "Estado": "Agendada"
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cita agendada con éxito')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agendar Cita")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ID del Médico'),
                keyboardType: TextInputType.number,
                onChanged: (value) => idMedico = int.tryParse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Motivo de la Cita'),
                onChanged: (value) => motivo = value,
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedDate != null && selectedTime != null) {
                    setState(() {
                      fechaHora = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                },
                child: Text("Seleccionar Fecha y Hora"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: agendarCita,
                child: Text('Agendar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
