import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarInfoUsuarios extends StatefulWidget {
  final String campo;
  final String valorActual;
  final String uid; // Agrega el campo uid

  EditarInfoUsuarios({required this.uid, required this.campo, required this.valorActual});

  @override
  _EditarInfoUsuariosState createState() => _EditarInfoUsuariosState();
}

class _EditarInfoUsuariosState extends State<EditarInfoUsuarios> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.valorActual);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${widget.campo}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nuevo ${widget.campo}',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardarCambios() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Actualizar el valor en Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.uid)
          .update({
            widget.campo: _controller.text,
          });
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cambios guardados con éxito'),
          backgroundColor: Colors.green,
        ),
      );
      // Regresar a la pantalla anterior
      Navigator.pop(context, true);;
    } catch (error) {
      // Manejar errores
      print('Error al guardar cambios: $error');
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar cambios. Inténtalo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
