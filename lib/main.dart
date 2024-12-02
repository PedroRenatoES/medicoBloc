import 'package:flutter/material.dart';
import 'package:flutter_medico_api_web_1/pantallas/inicioSesion.dart';
import 'package:flutter_medico_api_web_1/pantallas/pantallaAgendarCita.dart';
import 'package:flutter_medico_api_web_1/pantallas/pantallaPrincipal.dart';
import 'package:flutter_medico_api_web_1/pantallas/verCitasPantalla.dart';
import 'package:flutter_medico_api_web_1/pantallas/verHistorialMedico.dart';
import 'package:flutter_medico_api_web_1/pantallas/verMedicosPantalla.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Extrae el argumento pacienteId si está presente
        final args = settings.arguments as int?;

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/mainScreen':
            return MaterialPageRoute(builder: (context) => MainScreen(pacienteId: args!));
          case '/verCitas':
            return MaterialPageRoute(builder: (context) => VerCitasScreen(pacienteId: args!));
          case '/agendarCita':
            return MaterialPageRoute(builder: (context) => AgendarCitaScreen(pacienteId: args!));
          case '/historialMedico':
            return MaterialPageRoute(builder: (context) => HistorialMedicoScreen(pacienteId: args!));
          case '/verMedicos':
            return MaterialPageRoute(builder: (context) => VerMedicosScreen());
          default:
            return null;
        }
      },
    );
  }
}
