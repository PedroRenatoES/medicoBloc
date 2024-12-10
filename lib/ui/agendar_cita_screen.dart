import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_medico_api_web_1/bloc/appoinment_bloc.dart';
import 'package:flutter_medico_api_web_1/bloc/appoinment_state.dart';
import 'package:flutter_medico_api_web_1/services/appoinment_service.dart';
import '../bloc/appointment_event.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agendar Cita")),
      body: BlocProvider(
        create: (_) => AppointmentBloc(AppointmentService()),
        child: BlocListener<AppointmentBloc, AppointmentState>(
          listener: (context, state) {
            if (state is AppointmentLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Agendando cita...')),
              );
            } else if (state is AppointmentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cita agendada con éxito')),
              );
              Navigator.pop(context);
            } else if (state is AppointmentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              return Padding(
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
                        onPressed: () {
                          BlocProvider.of<AppointmentBloc>(context).add(
                            AppointmentSubmitted(
                              pacienteId: widget.pacienteId,
                              idMedico: idMedico,
                              fechaHora: fechaHora,
                              motivo: motivo,
                            ),
                          );
                        },
                        child: Text('Agendar'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
