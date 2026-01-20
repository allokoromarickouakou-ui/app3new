import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'env.dart';
import 'ecran_historique_crises.dart';
import 'ecran_alertes_predictions.dart';
import 'ecran_profil.dart';
import '../state/app_state.dart';
import '../widgets/chatbot_button.dart';

class RemissionPage extends StatelessWidget {
  const RemissionPage({super.key});

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
              decoration: BoxDecoration(color: Colors.purple.shade100, borderRadius: BorderRadius.circular(4)),
              child: const Text('Profil Rémission', style: TextStyle(fontSize: 11, color: Colors.purple, fontWeight: FontWeight.w600)),
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
            // CARTE STABILITÉ RÉELLE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: 160, height: 160, child: CircularProgressIndicator(value: 1.0, strokeWidth: 12, backgroundColor: Colors.grey[200], color: Colors.purple)),
                      const Column(children: [
                        Text('124', style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold)),
                        Text('jours stables', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('ÉTAT DE RÉMISSION CONFIRMÉ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Monitoring Environnemental (Live)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildMonitorCard('Qualité Air (AQI)', '${AppState.aqi}', AppState.aqiLevel, Colors.green),
            const SizedBox(height: 8),
            _buildMonitorCard('Météo Actuelle', '${AppState.temperature}°C', 'Température', Colors.orange),
            const SizedBox(height: 8),
            _buildMonitorCard('Humidité', '${AppState.humidity}%', 'Taux actuel', Colors.blue),
            const SizedBox(height: 24),
            // Widget IA Chatbot
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.purple.shade50, Colors.blue.shade50]), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  const Text('Besoin d\'un conseil personnalisé ?', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                    child: const Text('Discuter avec Dr. RespirIA'),
                  ),
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

  Widget _buildMonitorCard(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(subtitle, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ]),
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
