// user_info_button.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => UserInfoBottomSheet(),
        );
      },
      child: Icon(Icons.account_circle),
    );
  }
}

class UserInfoBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                // Aquí puedes mostrar la imagen de perfil del usuario
              ),
              SizedBox(height: 10),
              Text(
                'Nombre del Usuario',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Mostrar un mensaje emergente al cerrar sesión
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('¿Estas seguro?'),
                        content: Text('Se cerrará la sesión.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              _cerrarSesion(context);
                              },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Cerrar Sesión'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Acción para reportar un problema
                },
                child: Text('Reportar Problema'),
              ),
            ],
          ),
        ),
      ),
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