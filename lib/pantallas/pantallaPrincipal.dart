import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final int pacienteId;
  
  // Definiendo los colores de la paleta
  final Color primaryColor = Color(0xFF004D40);
  final Color secondaryColor = Color(0xFFD0E2FF);
  final Color accentColor = Color(0xFFB2DFDB);
  final Color darkColor = Color(0xFF00796B);

  MainScreen({Key? key, required this.pacienteId}) : super(key: key);

  Widget _buildOptionCard({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width * 0.43,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkColor,
                ),
              ),
            ],
          ),
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
          "Panel Principal",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Bienvenido!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gestiona tus citas médicas de forma fácil y rápida',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Servicios Disponibles',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildOptionCard(
                          title: 'Ver Citas',
                          icon: Icons.calendar_today,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/verCitas',
                            arguments: pacienteId,
                          ),
                          context: context,
                        ),
                        _buildOptionCard(
                          title: 'Agendar Cita',
                          icon: Icons.add_circle_outline,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/agendarCita',
                            arguments: pacienteId,
                          ),
                          context: context,
                        ),
                        _buildOptionCard(
                          title: 'Historial Médico',
                          icon: Icons.medical_information,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/historialMedico',
                            arguments: pacienteId,
                          ),
                          context: context,
                        ),
                        _buildOptionCard(
                          title: 'Ver Médicos',
                          icon: Icons.people,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/verMedicos',
                          ),
                          context: context,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}