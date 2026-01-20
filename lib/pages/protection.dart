import 'package:flutter/material.dart';
import 'env.dart';
import 'ecran_historique_crises.dart';
import 'ecran_alertes_predictions.dart';
import 'ecran_profil.dart';
import '../state/app_state.dart';
import '../widgets/chatbot_button.dart';

class ProtectionPage extends StatelessWidget {
  const ProtectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bonjour ${AppState.userName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(4)),
              child: const Text('Profil Protection', style: TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.black54), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARTE QUALITÉ AIR RÉELLE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
              child: Column(
                children: [
                  const Icon(Icons.air, size: 80, color: Colors.blue),
                  const SizedBox(height: 20),
                  const Text('QUALITÉ DE L\'AIR ACTUELLE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  const SizedBox(height: 16),
                  Text('${AppState.aqi}', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.green)),
                  Text(AppState.aqiLevel, style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Environnement et Météo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildInfoRow('Température', '${AppState.temperature}°C', Icons.thermostat, Colors.orange),
            const SizedBox(height: 8),
            _buildInfoRow('Humidité', '${AppState.humidity}%', Icons.water_drop, Colors.blue),
            const SizedBox(height: 8),
            _buildInfoRow('Particules PM2.5', '${AppState.pm25} µg/m³', Icons.grain, Colors.grey),
            const SizedBox(height: 24),
            const Text('Conseil IA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.shade200)),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 12),
                  Expanded(child: Text('L\'air est pur à Abidjan. Vous pouvez sortir sans masque en toute sécurité.', style: TextStyle(fontSize: 13))),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: const ChatbotButton(),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final labels = ['Accueil', 'Environnement', 'Alertes', 'Profil'];
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      currentIndex: 0,
      onTap: (index) {
        final label = labels[index];
        if (label == 'Environnement') Navigator.push(context, MaterialPageRoute(builder: (c) => const EnvironnementPage()));
        if (label == 'Alertes') Navigator.push(context, MaterialPageRoute(builder: (c) => const EcranAlertesPredictions()));
        if (label == 'Profil') Navigator.push(context, MaterialPageRoute(builder: (c) => const EcranProfil()));
      },
      items: labels.map((l) => BottomNavigationBarItem(icon: const Icon(Icons.circle, size: 0), label: l)).toList(),
    );
  }
}
