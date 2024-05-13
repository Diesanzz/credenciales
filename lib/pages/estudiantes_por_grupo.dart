import 'package:credenciales_alumnos/pages/info_estudiantes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Clase Estudiante
class Estudiante {
  final String boleta;
  final String uid;

  Estudiante({required this.boleta, required this.uid});
}

// Función para obtener estudiantes por grupo desde Firestore
Future<List<Estudiante>> obtenerEstudiantesPorGrupo(String grupo) async {
  try {
    // Obtener los documentos de la colección "usuarios" con el campo "grupo" igual al grupo proporcionado
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('usuarios')
        .where('grupo', isEqualTo: grupo)
        .get();

    // Convertir los documentos en objetos Estudiante
    List<Estudiante> estudiantes = querySnapshot.docs.map((doc) {
      return Estudiante(
        boleta: doc['boleta'],
        uid: doc.id, // El id del documento es el uid del estudiante
      );
    }).toList();

    return estudiantes;
  } catch (e) {
    print('Error al obtener estudiantes por grupo: $e');
    return []; // Devolver una lista vacía en caso de error
  }
}

// Pantalla de estudiantes por grupo
class EstudiantesPorGrupoScreen extends StatelessWidget {
  final String nombreGrupo;

  EstudiantesPorGrupoScreen({required this.nombreGrupo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudiantes del Grupo $nombreGrupo'),
      ),
      body: FutureBuilder<List<Estudiante>>(
        future: obtenerEstudiantesPorGrupo(nombreGrupo),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<Estudiante> estudiantes = snapshot.data ?? [];
          return ListView.builder(
            itemCount: estudiantes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navegar a la pantalla de información del estudiante seleccionado
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoEstudiantes(uid: estudiantes[index].uid),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(estudiantes[index].boleta),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
