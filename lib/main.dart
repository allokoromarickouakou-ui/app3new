import 'package:flutter/material.dart';
import 'pages/accueil.dart'; // On importe notre page d'accueil

// FONCTION PRINCIPALE - C'est ici que tout commence !
void main() {
  runApp(const MyApp()); // Lance l'application
}

// MyApp = Widget racine de toute l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // MaterialApp = Configure toute l'application
      
      title: 'RespirIA', // Nom de l'app
      
      debugShowCheckedModeBanner: false, // Enlève le bandeau "DEBUG" en haut
      
      theme: ThemeData(
        // Theme = Définit les couleurs et styles globaux de l'app
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Police par défaut
        useMaterial3: true, // Utilise Material Design 3 (plus moderne)
      ),
      
      home: const AccueilPage(), // Page qui s'affiche au démarrage
    );
  }
}