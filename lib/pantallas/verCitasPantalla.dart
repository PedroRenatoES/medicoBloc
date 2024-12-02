import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerCitasScreen extends StatefulWidget {
  final int pacienteId;
  VerCitasScreen({required this.pacienteId});

  @override
  _VerCitasScreenState createState() => _VerCitasScreenState();
}

class _VerCitasScreenState extends State<VerCitasScreen> {
  List<dynamic> citas = [];
  bool isLoading = false;

  // Definiendo los colores de la paleta
  final Color primaryColor = Color(0xFF004D40);
  final Color secondaryColor = Color(0xFFD0E2FF);
  final Color accentColor = Color(0xFFB2DFDB);
  final Color darkColor = Color(0xFF00796B);

  @override
  void initState() {
    super.initState();
    fetchCitas();
  }

  Future<void> fetchCitas() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse("https://4a43-189-28-68-207.ngrok-free.app/api/Citas/ver/${widget.pacienteId}"),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> citasData = jsonResponse['\$values'];
        setState(() {
          citas = citasData;
        });
      } else {
        _mostrarError('Error al cargar las citas');
      }
    } catch (e) {
      _mostrarError('Error de conexión');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text(
          "Mis Citas Médicas",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchCitas,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Historial de Citas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Gestiona tus citas médicas programadas',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  )
                : citas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 80,
                              color: darkColor.withOpacity(0.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay citas programadas',
                              style: TextStyle(
                                fontSize: 18,
                                color: darkColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                '/agendarCita',
                                arguments: widget.pacienteId,
                              ),
                              child: Text('Agendar Nueva Cita'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchCitas,
                        color: primaryColor,
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
                                              color: darkColor,
                                            ),
                                          ),
                                        ),
                                        _buildEstadoChip(cita['estado'] ?? 'Pendiente'),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, 
                                             color: primaryColor,
                                             size: 20),
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
                                          Icon(Icons.person, 
                                               color: primaryColor,
                                               size: 20),
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
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/agendarCita',
          arguments: widget.pacienteId,
        ),
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
        tooltip: 'Agendar Nueva Cita',
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
}