import 'package:flutter/material.dart';
import 'package:APP3/pages/loading_page.dart';

void main() {
  // Initialisation propre de l'application
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RespirIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      // L'application démarre sur le chargement puis redirige vers Login/Inscription
      home: const LoadingPage(),
    );
  }
}
