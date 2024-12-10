import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_medico_api_web_1/services/auth_service.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar Sesión"),
      ),
      body: BlocProvider(
        create: (_) => LoginBloc(AuthService()),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              // Mostrar indicador de carga
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Iniciando sesión...')),
              );
            } else if (state is LoginSuccess) {
              Navigator.pushNamed(context, '/mainScreen', arguments: state.pacienteId);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        onChanged: (value) => _email = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Contraseña'),
                        obscureText: true,
                        onChanged: (value) => _password = value,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<LoginBloc>(context).add(
                              LoginSubmitted(email: _email, password: _password),
                            );
                          }
                        },
                        child: Text('Iniciar Sesión'),
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
