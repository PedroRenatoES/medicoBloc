import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistorialMedicoScreen extends StatefulWidget {
  final int pacienteId;

  HistorialMedicoScreen({required this.pacienteId});

  @override
  _HistorialMedicoScreenState createState() => _HistorialMedicoScreenState();
}

class _HistorialMedicoScreenState extends State<HistorialMedicoScreen> {
  List<dynamic> historial = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchHistorial();
  }

  Future<void> fetchHistorial() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("https://4a43-189-28-68-207.ngrok-free.app/HistorialMedico/${widget.pacienteId}"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Debug: Imprimir el JSON para verificar su contenido
        print('JSON Response: $jsonResponse');

        if (jsonResponse.containsKey("\$values")) {
          setState(() {
            historial = jsonResponse["\$values"];
          });
        } else {
          print("Error: La clave '\$values' no existe en la respuesta.");
        }
      } else {
        print('Error: Código de estado HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching historial médico: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historial Médico")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : historial.isEmpty
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
                ),
    );
  }
}
