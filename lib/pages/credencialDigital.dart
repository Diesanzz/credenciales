import 'package:credenciales_alumnos/pages/user_info_button.dart';
import 'package:flutter/material.dart';

class CredencialDigital extends StatelessWidget {
  final String imageUrl;

  CredencialDigital(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credencial Digital'),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(  
              builder: (context) => ImageFullScreen(imageUrl),
            ),
          );
        },
        child: Center(
          child: Hero(
            tag: 'credencial_image_hero_tag',
            child: RotatedBox(
              quarterTurns: 1, // Rotar 90 grados en sentido contrario a las manecillas del reloj
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageFullScreen extends StatelessWidget {
  final String imageUrl;

  ImageFullScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'credencial_image_hero_tag',
            child: RotatedBox(
              quarterTurns: 1, // Rotar 90 grados en sentido contrario a las manecillas del reloj
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
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
