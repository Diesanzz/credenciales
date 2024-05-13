import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credenciales_alumnos/pages/editar_info_usarios.dart';
import 'package:flutter/material.dart';

class InfoEstudiantes extends StatefulWidget {
  final String uid;

  InfoEstudiantes({required this.uid});

  @override
  _InfoEstudiantesState createState() => _InfoEstudiantesState();
}

class _InfoEstudiantesState extends State<InfoEstudiantes> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _futureSnapshot;

  @override
  void initState() {
    super.initState();
    _futureSnapshot = FirebaseFirestore.instance.collection('usuarios').doc(widget.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Estudiante'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _futureSnapshot,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No se encontraron datos para este estudiante'));
          }
          var data = snapshot.data!.data()!;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField(context, 'Nombre', data['nombre']),
                _buildField(context, 'Apellido Paterno', data['apellidoPaterno']),
                _buildField(context, 'Apellido Materno', data['apellidoMaterno']),
                _buildField(context, 'Boleta', data['boleta']),
                _buildField(context, 'Grupo', data['grupo']),
                _buildField(context, 'Rol', data['rol']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(BuildContext context, String fieldName, String value) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla EditarInfoUsuarios con el campo correspondiente
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditarInfoUsuarios(campo: fieldName, valorActual: value, uid: widget.uid)),
        ).then((value) {
          // Llama a la función para recargar los datos después de guardar los cambios
          _reloadStudentData();
        });
      },
      child: Text('$fieldName: $value'),
    );
  }

  void _reloadStudentData() async {
    setState(() {
      _futureSnapshot = FirebaseFirestore.instance.collection('usuarios').doc(widget.uid).get();
    });
  }
}

