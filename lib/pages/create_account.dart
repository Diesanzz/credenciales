import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:credenciales_alumnos/pages/ingresar_detalles.dart';

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cuenta'),
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
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                String confirmPassword = _confirmPasswordController.text.trim();
                _crearCuentaWithEmailAndPassword(email, password, confirmPassword);
              },
              child: Text('Crear Cuenta'),
            ),
          ],
        ),
      ),
    );
  }

  void _crearCuentaWithEmailAndPassword(String email, String password, String confirmPassword) async {
    // Validar el correo electrónico
    if (!isValidEmail(email)) {
      _showErrorMessage('Correo electrónico inválido');
      return;
    }

    // Verificar si la contraseña coincide con la confirmación de la contraseña
    if (password != confirmPassword) {
      _showErrorMessage('Las contraseñas no coinciden');
      return;
    }

    // Validar la longitud de la contraseña
    if (password.length < 6) {
      _showErrorMessage('La contraseña es demasiado corta');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Usuario creado con éxito
      User? user = userCredential.user;
      print('Usuario creado: ${user!.uid}');
      // Navegar a la siguiente pantalla para que el usuario ingrese detalles adicionales
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IngresarDetallesScreen(user)));
    } catch (e) {
      // Manejar errores de creación de cuenta
      print('Error al crear la cuenta: $e');
      String errorMessage = 'Error al crear la cuenta. Por favor, intenta de nuevo.';
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Este correo electrónico ya está en uso';
        }
      }
      _showErrorMessage(errorMessage);
    }
  }

  bool isValidEmail(String email) {
    // Expresión regular para validar el correo electrónico
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
