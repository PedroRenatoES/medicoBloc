import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ver_citas_bloc.dart';
import '../bloc/ver_citas_event.dart';
import '../bloc/ver_citas_state.dart';

class VerCitasScreen extends StatelessWidget {
  final int pacienteId;
  VerCitasScreen({required this.pacienteId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerCitasBloc()..add(FetchCitasEvent(pacienteId: pacienteId)),
      child: Scaffold(
        backgroundColor: Color(0xFFD0E2FF),
        appBar: AppBar(
          title: Text(
            "Mis Citas Médicas",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF004D40),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => BlocProvider.of<VerCitasBloc>(context).add(FetchCitasEvent(pacienteId: pacienteId)),
              tooltip: 'Actualizar',
            ),
          ],
        ),
        body: BlocBuilder<VerCitasBloc, VerCitasState>(
          builder: (context, state) {
            if (state is VerCitasLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF004D40)),
                ),
              );
            } else if (state is VerCitasError) {
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
                      onPressed: () => BlocProvider.of<VerCitasBloc>(context).add(FetchCitasEvent(pacienteId: pacienteId)),
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
            } else if (state is VerCitasLoaded) {
              final citas = state.citas;
              return citas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 80,
                            color: Color(0xFF00796B).withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No hay citas programadas',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF00796B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/agendarCita',
                              arguments: pacienteId,
                            ),
                            child: Text('Agendar Nueva Cita'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF004D40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<VerCitasBloc>(context)
                            .add(FetchCitasEvent(pacienteId: pacienteId));
                      },
                      color: Color(0xFF004D40),
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: citas.length,
                        itemBuilder: (context, index) {
                          final cita = citas[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          cita['motivo'] ?? 'Sin motivo',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF00796B),
                                          ),
                                        ),
                                      ),
                                      _buildEstadoChip(cita['estado'] ?? 'Pendiente'),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, color: Color(0xFF004D40), size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        formatearFecha(cita['fechaHora']),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (cita['doctor'] != null) ...[
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.person, color: Color(0xFF004D40), size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Dr. ${cita['doctor']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
            } else {
              return Container(); // Estado inicial vacío
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/agendarCita',
            arguments: pacienteId,
          ),
          backgroundColor: Color(0xFF004D40),
          child: Icon(Icons.add),
          tooltip: 'Agendar Nueva Cita',
        ),
      ),
    );
  }

  String formatearFecha(String? fechaStr) {
    if (fechaStr == null) return 'Fecha no disponible';
    try {
      final fecha = DateTime.parse(fechaStr);
      return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Fecha no disponible';
    }
  }

  Widget _buildEstadoChip(String estado) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getEstadoColor(estado).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getEstadoColor(estado),
          width: 1,
        ),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: _getEstadoColor(estado),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'completada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      case 'pendiente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
