import 'package:credenciales_alumnos/pages/user_info_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credenciales_alumnos/pages/credencialDigital.dart';

class CredencialesScreen extends StatefulWidget {
  final String userId;

  CredencialesScreen(this.userId);

  @override
  _CredencialesScreenState createState() => _CredencialesScreenState();
}

class _CredencialesScreenState extends State<CredencialesScreen> {
  String _nombreEstudiante = '';

  @override
  void initState() {
    super.initState();
    // Obtener el nombre del estudiante al iniciar la pantalla
    _obtenerNombreEstudiante();
  }

  Future<void> _obtenerNombreEstudiante() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('usuarios').doc(widget.userId).get();
      if (snapshot.exists) {
        setState(() {
          // Concatenar los campos de nombre completo (apellidos y nombre)
          _nombreEstudiante = '${snapshot['apellidoPaterno']} ${snapshot['apellidoMaterno']} ${snapshot['nombre']}';
        });
      } else {
        print('No se encontraron datos para este usuario');
      }
    } catch (e) {
      print('Error al obtener el nombre del estudiante: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credenciales'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              '¡Bienvenid@, $_nombreEstudiante!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 20),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('usuarios').doc(widget.userId).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No se encontraron datos para este usuario'));
                }
                var data = snapshot.data!.data()! as Map<String, dynamic>; // Conversión a Map<String, dynamic>
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Información del Estudiante',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    _buildInfoCard('Nombre Completo', '${data['apellidoPaterno']} ${data['apellidoMaterno']} ${data['nombre']}'),
                    _buildInfoCard('Boleta', data['boleta']),
                    _buildInfoCard('Grupo', data['grupo']),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navegar a la pantalla CredencialDigital
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CredencialDigital(data['urlImagen'])),
                        );
                      },
                      child: Text('Ver Credencial Digital'),
                    ),
                    SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Cerrar sesión
                      _cerrarSesion(context);
                    },
                    child: Text('Cerrar Sesión'),
                  ),
                  ],
                );
              },
            ),
            // Aquí puedes mostrar más detalles de las credenciales si es necesario
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}


class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: Center(
        child: Text('Contenido de la pantalla de usuario'),
      ),
      floatingActionButton: UserInfoButton(),
    );
  }
}

void _cerrarSesion(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/sesion');
  } catch (e) {
    print('Error al cerrar sesión: $e');
    // Manejar el error
  }
}
