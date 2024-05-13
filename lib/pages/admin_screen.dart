import 'package:credenciales_alumnos/pages/estudiantes_por_grupo.dart';
import 'package:credenciales_alumnos/pages/user_info_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administración'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semestres',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('semestres').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final semestres = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: semestres.length,
                    itemBuilder: (context, index) {
                      final semestre = semestres[index];
                      return SemestreCard(semestre: semestre);
                    },
                  );
                },
              ),
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
        ),
      ),
      floatingActionButton: UserInfoButton(), // Añade el botón UserInfoButton como floatingActionButton
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop, // Ubicación en la esquina superior derecha
    );
  }
}

class SemestreCard extends StatelessWidget {
  final QueryDocumentSnapshot semestre;

  SemestreCard({required this.semestre});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          // Mostrar los grupos del semestre al hacer clic
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GruposScreen(semestre: semestre)),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            semestre['xd'], // Suponiendo que el nombre del semestre está en el campo 'nombre'
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class GruposScreen extends StatelessWidget {
  final QueryDocumentSnapshot semestre;

  GruposScreen({required this.semestre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(semestre['xd']), // Mostrar el nombre del semestre en la barra de navegación
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grupos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: semestre.reference.collection('grupos').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final grupos = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: grupos.length,
                    itemBuilder: (context, index) {
                      final grupo = grupos[index];
                      return GrupoCard(grupo: grupo);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GrupoCard extends StatelessWidget {
  final QueryDocumentSnapshot grupo;

  GrupoCard({required this.grupo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EstudiantesPorGrupoScreen(nombreGrupo: grupo['grupo']),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            grupo['grupo'], // Suponiendo que el nombre del grupo está en el campo 'grupo'
            style: TextStyle(fontSize: 18),
          ),
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