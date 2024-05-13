import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void vincularUsuarioAFirestore(User user) async {
  // Referencia al documento del usuario en Firestore utilizando su UID
  DocumentReference userDocRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);

  // Verificar si el documento del usuario ya existe en Firestore
  bool userExists = await userDocRef.get().then((doc) => doc.exists);

  // Si el documento no existe, crea uno nuevo y establece la información del usuario
  if (!userExists) {
    await userDocRef.set({
      // Puedes guardar cualquier información adicional del usuario aquí
      // Por ejemplo, el nombre de usuario, dirección de correo electrónico, etc.
      'nombre': user.displayName,
      'email': user.email,
      // Puedes agregar más campos según sea necesario
    });
  }
}

