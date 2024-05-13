import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class IngresarDetallesScreen extends StatefulWidget {
  final User user;

  IngresarDetallesScreen(this.user);

  @override
  _IngresarDetallesScreenState createState() => _IngresarDetallesScreenState();
}

class _IngresarDetallesScreenState extends State<IngresarDetallesScreen> {
  TextEditingController _apellidoPaternoController = TextEditingController();
  TextEditingController _apellidoMaternoController = TextEditingController();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _boletaController = TextEditingController();
  TextEditingController _grupoController = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar Detalles'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _apellidoPaternoController,
              decoration: InputDecoration(
                labelText: 'Apellido Paterno',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _apellidoMaternoController,
              decoration: InputDecoration(
                labelText: 'Apellido Materno',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre(s)',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _boletaController,
              decoration: InputDecoration(
                labelText: 'Número de Boleta (10 dígitos)',
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _grupoController,
              decoration: InputDecoration(
                labelText: 'Grupo (Mayúsculas)',
              ),
              onChanged: (value) {
                _grupoController.text = value.toUpperCase();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _pickImage();
              },
              child: Text('Seleccionar Imagen'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String apellidoPaterno = _apellidoPaternoController.text.trim();
                String apellidoMaterno = _apellidoMaternoController.text.trim();
                String nombre = _nombreController.text.trim();
                String boleta = _boletaController.text.trim();
                String grupo = _grupoController.text.trim();
                _crearDocumentoFirestore(apellidoPaterno, apellidoMaterno, nombre, boleta, grupo);
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _crearDocumentoFirestore(String apellidoPaterno, String apellidoMaterno, String nombre, String boleta, String grupo) async {
    try {
      // Subir la imagen a Firebase Storage
      String imageUrl = await _uploadImage();

      // Referencia al documento del usuario en Firestore utilizando su UID
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('usuarios').doc(widget.user.uid);

      // Crear el documento en Firestore con los detalles proporcionados y la URL de la imagen
      await userDocRef.set({
        'apellidoPaterno': apellidoPaterno,
        'apellidoMaterno': apellidoMaterno,
        'nombre': nombre,
        'boleta': boleta,
        'grupo': grupo,
        'urlImagen': imageUrl,
      });

      // Navegar a la siguiente pantalla o realizar cualquier otra acción después de crear el documento
      // Por ejemplo, puedes navegar a la pantalla principal de la aplicación
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Manejar errores de Firestore
      print('Error al crear el documento en Firestore: $e');
      // Aquí puedes mostrar un mensaje de error al usuario si falla la creación del documento
    }
  }

  Future<String> _uploadImage() async {
    if (_imageFile == null) return '';

    try {
      final storageRef = firebase_storage.FirebaseStorage.instance.ref().child('images/${widget.user.uid}.jpg');
      await storageRef.putFile(_imageFile!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error al subir la imagen: $e');
      return '';
    }
  }
}



