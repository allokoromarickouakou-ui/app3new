
// Importe les packages nécessaires et le widget de la barre de navigation.
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'env.dart';
import 'ecran_alertes_predictions.dart';
import 'ecran_profil.dart';
import '../state/app_state.dart';
import '../widgets/chatbot_button.dart';

// Définit la classe principale de la page, nommée en français.
class EcranHistoriqueCrises extends StatelessWidget {
  const EcranHistoriqueCrises({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Historique des crises',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
                const SizedBox(height: 20),

                // Statistiques Dynamiques depuis AppState
                Row(
                  children: [
                    Expanded(
                      child: CarteCrise(
                        title: 'Ce mois',
                        value: '${AppState.crisesThisMonth}',
                        subtitle: 'Crises détectées',
                        icon: Icons.show_chart,
                        iconColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CarteCrise(
                        title: 'Jours sans crise',
                        value: '${AppState.daysWithoutCrisis}',
                        subtitle: 'Stabilité actuelle',
                        icon: Icons.calendar_today,
                        iconColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const GraphiqueCrisesMensuel(),
                const SizedBox(height: 32),
                
                // Patterns IA Réels
                const PatternsDetectesCard(),
                const SizedBox(height: 24),
                
                Text(
                  'Historique Détaillé',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Liste dynamique de l'historique
                if (AppState.crisisHistory.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Aucune crise enregistrée ce mois-ci.", style: TextStyle(color: Colors.grey)),
                  ))
                else
                  ...AppState.crisisHistory.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: HistoriqueCriseItem(
                      date: item['date'] ?? "Date inconnue",
                      duree: item['duration'] ?? "N/A",
                      spo2: item['spo2'] ?? "N/A",
                      facteur: item['trigger'] ?? "Inconnu",
                      severite: item['severity'] ?? "normale",
                    ),
                  )),

                const SizedBox(height: 32),
                const VueCalendrier(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const ChatbotButton(),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      currentIndex: 2,
      onTap: (index) {
        if (index == 0) Navigator.popUntil(context, (route) => route.isFirst);
        if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (c) => const EnvironnementPage()));
        if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (c) => const EcranAlertesPredictions()));
        if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (c) => const EcranProfil()));
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file_outlined), label: 'Environnement'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Crises'),
        BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Alertes'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
      ],
    );
  }
}

// Widget pour une carte de statistique
class CarteCrise extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const CarteCrise({super.key, required this.title, required this.value, required this.subtitle, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, color: iconColor), const SizedBox(width: 8), Expanded(child: Text(title, style: const TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis))]),
            const SizedBox(height: 16),
            Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// Graphique (Reste statique pour l'instant car dépend de fl_chart)
class GraphiqueCrisesMensuel extends StatelessWidget {
  const GraphiqueCrisesMensuel({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Text('Tendance mensuelle', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(height: 150, child: BarChart(BarChartData(barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5, color: Colors.blue)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3, color: Colors.blue)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: AppState.crisesThisMonth.toDouble(), color: Colors.orange)]),
          ]))),
        ]),
      ),
    );
  }
}

// Carte des patterns IA
class PatternsDetectesCard extends StatelessWidget {
  const PatternsDetectesCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(Icons.smart_toy_outlined, color: Colors.blue.shade800), const SizedBox(width: 8), const Text('Analyses IA', style: TextStyle(fontWeight: FontWeight.bold))]),
          const SizedBox(height: 16),
          if (AppState.aiPatterns.isEmpty)
            const Text("L'IA n'a pas encore assez de données pour détecter des patterns.")
          else
            ...AppState.aiPatterns.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(children: [const Icon(Icons.circle, color: Colors.orange, size: 8), const SizedBox(width: 8), Expanded(child: Text(p))]),
            )),
        ]),
      ),
    );
  }
}

// Item historique
class HistoriqueCriseItem extends StatelessWidget {
  final String date, duree, spo2, facteur, severite;
  const HistoriqueCriseItem({super.key, required this.date, required this.duree, required this.spo2, required this.facteur, required this.severite});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Facteur: $facteur | Durée: $duree'),
        trailing: Chip(label: Text(severite), backgroundColor: Colors.orange.shade50),
      ),
    );
  }
}

// Vue calendrier simplifiée
class VueCalendrier extends StatelessWidget {
  const VueCalendrier({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Text('Aperçu Temporel', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text("Dernière analyse effectuée aujourd'hui à 12h00", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
      ),
    );
  }
}
