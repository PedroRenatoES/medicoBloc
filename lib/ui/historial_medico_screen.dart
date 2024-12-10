import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/historial_medico_bloc.dart';
import '../bloc/historial_medico_event.dart';
import '../bloc/historial_medico_state.dart';

class HistorialMedicoScreen extends StatelessWidget {
  final int pacienteId;

  HistorialMedicoScreen({required this.pacienteId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistorialMedicoBloc()..add(FetchHistorialMedicoEvent(pacienteId)),
      child: Scaffold(
        appBar: AppBar(title: Text("Historial Médico")),
        body: BlocBuilder<HistorialMedicoBloc, HistorialMedicoState>(
          builder: (context, state) {
            if (state is HistorialMedicoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is HistorialMedicoError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 80,
                      color: Colors.red.withOpacity(0.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      state.mensaje,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => BlocProvider.of<HistorialMedicoBloc>(context)
                          .add(FetchHistorialMedicoEvent(pacienteId)),
                      child: Text('Intentar de nuevo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF004D40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is HistorialMedicoLoaded) {
              final historial = state.historial;
              return historial.isEmpty
                  ? Center(child: Text('No hay registros en el historial médico.'))
                  : ListView.builder(
                      itemCount: historial.length,
                      itemBuilder: (context, index) {
                        final registro = historial[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fecha: ${registro['fecha'] ?? 'No disponible'}",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Descripción: ${registro['descripcion'] ?? 'No disponible'}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Diagnóstico: ${registro['diagnostico'] ?? 'No disponible'}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Tratamiento: ${registro['tratamiento'] ?? 'No disponible'}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            } else {
              return Container(); // Estado inicial vacío
            }
          },
        ),
      ),
    );
  }
}
