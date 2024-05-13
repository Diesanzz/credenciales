import 'package:credenciales_alumnos/pages/create_account.dart';
import 'package:credenciales_alumnos/pages/inicio_sesion.dart';
import 'package:flutter/material.dart';


//importaciones de firebase 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Material App',
      initialRoute: '/sesion',
      routes:{
        '/sesion':(context) => InicioSesion(),
        '/create':(context) => RegistroScreen(),
      } ,
    );
  }
}


