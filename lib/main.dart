import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_medico_api_web_1/bloc/ver_citas_bloc.dart';
import 'package:flutter_medico_api_web_1/ui/agendar_cita_screen.dart';
import 'package:flutter_medico_api_web_1/ui/historial_medico_screen.dart';
import 'package:flutter_medico_api_web_1/ui/login_screen.dart';
import 'package:flutter_medico_api_web_1/ui/mainScreen.dart';
import 'package:flutter_medico_api_web_1/ui/ver_citas_screen.dart';
import 'package:flutter_medico_api_web_1/ui/ver_medicos_screen.dart';


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
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => VerCitasBloc(),
                child: VerCitasScreen(pacienteId: args!),
              ),
            );
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
