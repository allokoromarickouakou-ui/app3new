
import 'package:flutter/material.dart';
import 'package:APP3/pages/asthmatique.dart';
import 'package:APP3/pages/protection.dart';
import 'package:APP3/pages/remission.dart';
import 'package:APP3/state/app_state.dart';
import 'package:APP3/services/auth_service.dart';
import 'package:APP3/pages/login_page.dart'; // Import de la page de login

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final AuthService _authService = AuthService();

  String? _selectedProfileType;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedProfileType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner un type de profil')),
        );
        return;
      }

      setState(() => _isLoading = true);

      final success = await _authService.login(
        _emailController.text, 
        _passwordController.text
      );

      setState(() => _isLoading = false);

      if (success) {
        Widget page;
        switch (_selectedProfileType) {
          case 'patient':
            AppState.hideCrises = false;
            page = const AsthmatiquePage();
            break;
          case 'prevention':
            AppState.hideCrises = true;
            page = const ProtectionPage();
            break;
          case 'remission':
            AppState.hideCrises = true;
            page = const RemissionPage();
            break;
          default:
            return;
        }

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => page),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur de connexion au serveur. Vérifiez vos identifiants.')),
          );
        }
      }
    }
  }

  Widget _buildProfileTypeChips() {
    return Wrap(
      spacing: 12.0,
      runSpacing: 8.0,
      children: [
        _buildChip('patient', 'Patient', Icons.personal_injury_outlined),
        _buildChip('prevention', 'Prévention', Icons.shield_outlined),
        _buildChip('remission', 'Rémission', Icons.favorite_border),
      ],
    );
  }

  Widget _buildChip(String id, String label, IconData icon) {
    final isSelected = _selectedProfileType == id;
    return ChoiceChip(
      label: Text(label),
      avatar: Icon(icon, color: isSelected ? Colors.white : Theme.of(context).primaryColor),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedProfileType = selected ? id : null;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
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
                    Text(
                      'Créer votre compte',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue[800]),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Rejoignez notre communauté en quelques étapes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Nom d'utilisateur",
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? "Champ requis" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value == null || value.isEmpty || !value.contains('@')) ? 'Email invalide' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe (min. 8 caractères)',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      validator: (value) => (value == null || value.length < 8) ? 'Minimum 8 caractères' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordConfirmController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        prefixIcon: Icon(Icons.lock_person_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      validator: (value) => (value != _passwordController.text) ? 'Mots de passe différents' : null,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Quel est votre profil ?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.blue[800]),
                    ),
                    const SizedBox(height: 12),
                    _buildProfileTypeChips(),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        elevation: 2,
                      ),
                      child: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("S'INSCRIRE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Déjà un compte ?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text("Se connecter", style: TextStyle(fontWeight: FontWeight.bold)),
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
