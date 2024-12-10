import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_medico_api_web_1/bloc/ver_medicos_bloc.dart';
import '../bloc/ver_medicos_event.dart';
import '../bloc/ver_medicos_state.dart';

class VerMedicosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerMedicosBloc()..add(FetchMedicosEvent()),
      child: Scaffold(
        backgroundColor: Color(0xFFD0E2FF),
        appBar: AppBar(
          title: Text(
            "Médicos Disponibles",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF004D40),
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: Color(0xFF004D40),
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
                          labelStyle: TextStyle(color: Color(0xFF00796B)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.search, color: Color(0xFF00796B)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          final especialidadId = int.tryParse(value);
                          BlocProvider.of<VerMedicosBloc>(context)
                              .add(FetchMedicosEvent(especialidadId: especialidadId));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<VerMedicosBloc, VerMedicosState>(
                  builder: (context, state) {
                    if (state is VerMedicosLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF004D40)),
                        ),
                      );
                    } else if (state is VerMedicosError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              size: 64,
                              color: Color(0xFF00796B),
                            ),
                            SizedBox(height: 16),
                            Text(
                              state.mensaje,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF00796B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is VerMedicosLoaded) {
                      final medicos = state.medicos;
                      return medicos.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Color(0xFF00796B),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No hay médicos disponibles',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF00796B),
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
                            );
                    } else {
                      return Container(); // Estado inicial vacío
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                color: Color(0xFFB2DFDB),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 30,
                color: Color(0xFF004D40),
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
                      color: Color(0xFF00796B),
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
}
