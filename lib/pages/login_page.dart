
import 'package:flutter/material.dart';
import 'package:APP3/pages/asthmatique.dart';
import 'package:APP3/pages/protection.dart';
import 'package:APP3/pages/remission.dart';
import 'package:APP3/state/app_state.dart';
import 'package:APP3/services/auth_service.dart';
import 'package:APP3/services/backend_service.dart';
import 'package:APP3/pages/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // 1. Login réel (récupère le profil réel du backend)
      final success = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (success) {
        // 2. Synchronisation réelle des capteurs
        await BackendService.testEnvironment(5.360, -4.008);

        // 3. Redirection basée sur le profileType RÉEL du backend
        Widget page;
        if (AppState.profileType == 'patient') {
          page = const AsthmatiquePage();
        } else if (AppState.profileType == 'remission') {
          page = const RemissionPage();
        } else {
          page = const ProtectionPage();
        }

        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => page),
          );
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Échec de la connexion. Vérifiez vos identifiants.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('RespirIA', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withAlpha(20),
                    spreadRadius: 5,
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.lock_person_outlined, size: 60, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      'Connexion Sécurisée',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                    ),
                    const SizedBox(height: 8),
                    const Text('Accédez à vos données en temps réel.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.blue.withAlpha(5),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.blue.withAlpha(5),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        elevation: 2,
                      ),
                      child: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("SE CONNECTER", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Nouveau ?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const RegistrationPage()),
                            );
                          },
                          child: const Text("Créer un compte", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
