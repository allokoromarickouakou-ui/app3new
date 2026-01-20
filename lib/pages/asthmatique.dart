import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'env.dart';
import 'ecran_historique_crises.dart';
import 'ecran_alertes_predictions.dart';
import 'ecran_profil.dart';
import '../state/app_state.dart';
import '../widgets/chatbot_button.dart';

class AsthmatiquePage extends StatelessWidget {
  const AsthmatiquePage({super.key});

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
              decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
              child: const Text('Asthme contrôlé', style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.bluetooth, color: Colors.blue), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.black54), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARTE RISQUE (Dynamique)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(16), 
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(width: 140, height: 140, child: CircularProgressIndicator(value: 0.18, strokeWidth: 12, backgroundColor: Colors.grey[200], color: Colors.green)),
                      Column(children: [
                        const Text('18', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87)),
                        Text('/100', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('RISQUE FAIBLE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Données vitales en temps réel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            
            // GRILLE DE DONNÉES (BRANCHÉE SUR APPSTATE)
            Row(
              children: [
                Expanded(child: _buildVitalCard('SpO2', '${AppState.spo2}%', 'Normal', Icons.favorite_border, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildVitalCard('Respiration', '14/min', 'Normal', Icons.air, Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildVitalCard('Cœur', '${AppState.heartRate} bpm', 'Repos', Icons.favorite, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildVitalCard('Température', '${AppState.temperature}°C', 'Météo Locale', Icons.thermostat, Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInfoCard('Air (AQI ${AppState.aqi})', AppState.aqiLevel, 'Abidjan', Icons.cloud_outlined, Colors.blue, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoCard('Activité', 'Repos', 'Normal', Icons.directions_walk, Colors.blue, Colors.grey)),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: const ChatbotButton(),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildVitalCard(String label, String value, String subtitle, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 12),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _buildInfoCard(String title, String value, String subtitle, IconData icon, Color iconColor, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 12),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
        Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ]),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final labels = AppState.hideCrises ? ['Accueil', 'Environnement', 'Alertes', 'Profil'] : ['Accueil', 'Environnement', 'Crises', 'Alertes', 'Profil'];
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      currentIndex: 0,
      onTap: (index) {
        final label = labels[index];
        if (label == 'Environnement') Navigator.push(context, MaterialPageRoute(builder: (c) => const EnvironnementPage()));
        if (label == 'Crises') Navigator.push(context, MaterialPageRoute(builder: (c) => const EcranHistoriqueCrises()));
        if (label == 'Alertes') Navigator.push(context, MaterialPageRoute(builder: (c) => const EcranAlertesPredictions()));
        if (label == 'Profil') Navigator.push(context, MaterialPageRoute(builder: (c) => const EcranProfil()));
      },
      items: labels.map((l) => BottomNavigationBarItem(icon: const Icon(Icons.circle, size: 0), label: l)).toList(),
    );
  }
}
