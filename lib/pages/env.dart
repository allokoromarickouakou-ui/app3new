import 'package:flutter/material.dart';
import 'ecran_historique_crises.dart';
import 'ecran_alertes_predictions.dart';
import 'ecran_profil.dart';
import '../state/app_state.dart';
import '../widgets/chatbot_button.dart';

class EnvironnementPage extends StatelessWidget {
  const EnvironnementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Environnement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text('Abidjan, Côte d\'Ivoire', style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARTE QUALITÉ AIR RÉELLE (AppState)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
              child: Column(
                children: [
                  const Text('Qualité de l\'air actuelle', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 120, height: 120,
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      child: Center(child: Text('${AppState.aqi}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(AppState.aqiLevel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // DÉTAILS POLLUANTS (DYNAMIQUE)
            _buildPollutantBar('Particules PM2.5', '${AppState.pm25} µg/m³', 0.3),
            const SizedBox(height: 12),
            _buildPollutantBar('Température', '${AppState.temperature}°C', 0.6),
            const SizedBox(height: 12),
            _buildPollutantBar('Humidité', '${AppState.humidity}%', 0.5),
            const SizedBox(height: 20),
            
            // RECOMMANDATION IA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Conseil RespirIA', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(child: Text('L\'AQI de ${AppState.aqi} est considéré comme ${AppState.aqiLevel.toLowerCase()}. Profitez-en pour aérer votre logement.', style: const TextStyle(fontSize: 13))),
                  ]),
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

  Widget _buildPollutantBar(String label, String value, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], color: Colors.blue, minHeight: 8),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final labels = AppState.hideCrises ? ['Accueil', 'Environnement', 'Alertes', 'Profil'] : ['Accueil', 'Environnement', 'Crises', 'Alertes', 'Profil'];
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      currentIndex: 1, // Environnement
      onTap: (index) {
        final label = labels[index];
        if (label == 'Accueil') Navigator.popUntil(context, (route) => route.isFirst);
        if (label == 'Profil') Navigator.push(context, MaterialPageRoute(builder: (c) => const EcranProfil()));
      },
      items: labels.map((l) => BottomNavigationBarItem(icon: const Icon(Icons.circle, size: 0), label: l)).toList(),
    );
  }
}
