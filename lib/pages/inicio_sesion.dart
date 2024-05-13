import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credenciales_alumnos/pages/admin_screen.dart';
import 'package:credenciales_alumnos/pages/credenciales.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                _signInWithEmailAndPassword(email, password);
              },
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de registro cuando se presione el botón
                Navigator.pushNamed(context, '/create');
              },
              child: Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }

  // Función para iniciar sesión con correo y contraseña
  void _signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Usuario autenticado con éxito
    User? user = userCredential.user;
    print('Usuario autenticado: ${user!.uid}');

    // Obtener el documento del usuario de Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();
    if (userDoc.exists) {
      // Obtener el rol del usuario
      String? role = userDoc.get('rol');

      // Redirigir al usuario según su rol
      if (role == 'estudiante') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CredencialesScreen(user.uid),
          ),
        );
      } else if (role == 'profesor') {
        // Redirigir a la pantalla de profesor
      } else if (role == 'administrador') {
        // Redirigir a la pantalla de administrador
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      }
    } else {
      print('No se encontró el documento de usuario');
    }

  } catch (e) {
    // Manejar errores de autenticación
    print('Error de autenticación: $e');
    // Mostrar mensaje emergente de error al iniciar sesión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No se pudo iniciar sesión. Verifica tus credenciales e intenta de nuevo.'),
      ),
    );
  }
}

}





