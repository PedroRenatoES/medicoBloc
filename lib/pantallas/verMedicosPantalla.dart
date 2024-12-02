import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerMedicosScreen extends StatefulWidget {
  @override
  _VerMedicosScreenState createState() => _VerMedicosScreenState();
}

class _VerMedicosScreenState extends State<VerMedicosScreen> {
  List<dynamic> medicos = [];
  int? especialidadId;
  bool isLoading = false;

  // Definiendo los colores de la paleta
  final Color primaryColor = Color(0xFF004D40);
  final Color secondaryColor = Color(0xFFD0E2FF);
  final Color accentColor = Color(0xFFB2DFDB);
  final Color darkColor = Color(0xFF00796B);

  @override
  void initState() {
    super.initState();
    fetchMedicos();
  }

  Future<void> fetchMedicos() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = especialidadId != null
          ? "https://4a43-189-28-68-207.ngrok-free.app/api/Medicos?especialidadId=$especialidadId"
          : "https://4a43-189-28-68-207.ngrok-free.app/api/Medicos";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          medicos = jsonResponse['\$values'];
        });
      }
    } catch (e) {
      print('Error en la petición: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildMedicoCard(dynamic medico) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 30,
                color: primaryColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${medico['nombre']} ${medico['apellido']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ID: ${medico['idMedico']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          "Médicos Disponibles",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              color: primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Encuentra tu médico',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Buscar por ID de Especialidad',
                        labelStyle: TextStyle(color: darkColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.search, color: darkColor),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          especialidadId = int.tryParse(value);
                        });
                        fetchMedicos();
                      },
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
                  : medicos.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: darkColor,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No hay médicos disponibles',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: darkColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(top: 16),
                          itemCount: medicos.length,
                          itemBuilder: (context, index) {
                            return _buildMedicoCard(medicos[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}