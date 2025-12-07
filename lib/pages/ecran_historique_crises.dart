// Importe les packages nécessaires et le widget de la barre de navigation.
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'env.dart';
import 'ecran_alertes_predictions.dart';
import 'ecran_profil.dart';

// Définit la classe principale de la page, nommée en français.
class EcranHistoriqueCrises extends StatelessWidget {
  const EcranHistoriqueCrises({super.key});

  // La méthode build dessine l'interface de la page.
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
                const SizedBox(height: 20), // Espace vertical.

                // Row organise les deux cartes de statistiques horizontalement.
                const Row(
                  children: [
                    // Expanded permet à chaque carte de prendre la moitié de l'espace disponible.
                    Expanded(
                      child: CarteCrise(
                        title: 'Ce mois',
                        value: '3',
                        subtitle: '-40% vs mois dernier',
                        icon: Icons.show_chart,
                        iconColor: Colors.orange,
                        subtitleIcon: Icons.trending_down,
                        subtitleIconColor: Colors.green,
                      ),
                    ),
                    SizedBox(width: 16), // Espace entre les deux cartes.
                    Expanded(
                      child: CarteCrise(
                        title: 'Jours sans crise',
                        value: '28',
                        subtitle: 'Dernière: il y a 28j',
                        icon: Icons.calendar_today,
                        iconColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Affiche le widget du graphique mensuel.
                const GraphiqueCrisesMensuel(),
                const SizedBox(height: 32),
                // Affiche le widget des patterns détectés.
                const PatternsDetectesCard(),
                const SizedBox(height: 24),
                // Titre pour la section de l'historique détaillé.
                Text(
                  'Historique',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Affiche le premier item de l'historique de crise.
                const HistoriqueCriseItem(
                  date: '20 octobre à 22:30',
                  duree: '12 minutes',
                  spo2: '91%',
                  facteur: 'Exercice',
                  severite: 'modérée',
                ),
                const SizedBox(height: 16),
                // Affiche le deuxième item de l'historique.
                 const HistoriqueCriseItem(
                  date: '5 octobre à 06:15',
                  duree: '8 minutes',
                  spo2: '93%',
                  facteur: 'Pollution',
                  severite: 'légère',
                ),
                const SizedBox(height: 16),
                // Affiche le troisième item de l'historique.
                 const HistoriqueCriseItem(
                  date: '28 septembre à 23:45',
                  duree: '15 minutes',
                  spo2: '90%',
                  facteur: 'Pollen',
                  severite: 'modérée',
                ),
                const SizedBox(height: 32),
                // Affiche le widget du calendrier à la fin de la page.
                const VueCalendrier(),
                const SizedBox(height: 80), // Espace pour la barre de navigation
              ],
            ),
          ),
        ),
      ),
      
      // === BARRE DE NAVIGATION ===
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        currentIndex: 2, // Crises sélectionné
        selectedFontSize: 12,
        unselectedFontSize: 12,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          if (index == 0) {
            // Retour à la page Accueil
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            // Navigation vers Environnement
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EnvironnementPage()),
            );
          } else if (index == 3) {
            // Navigation vers Alertes
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EcranAlertesPredictions()),
            );
          } else if (index == 4) {
            // Navigation vers Profil
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EcranProfil()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file_outlined),
            activeIcon: Icon(Icons.insert_drive_file),
            label: 'Environnement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            activeIcon: Icon(Icons.show_chart),
            label: 'Crises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'Alertes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS RÉUTILISABLES DE LA PAGE ---

// Widget pour une carte de statistique simple (ex: 'Ce mois').
class CarteCrise extends StatelessWidget {
  // Déclaration des propriétés finales que ce widget attend de recevoir.
  final String title;          // Titre de la carte, ex: 'Ce mois'.
  final String value;          // Valeur principale, ex: '3'.
  final String subtitle;       // Sous-titre, ex: '-40% vs mois dernier'.
  final IconData icon;         // L'icône principale de la carte.
  final Color iconColor;       // La couleur de l'icône principale.
  final IconData? subtitleIcon; // Une icône optionnelle pour le sous-titre (le `?` signifie qu'elle peut être nulle).
  final Color? subtitleIconColor; // La couleur de l'icône du sous-titre (peut aussi être nulle).

  // Constructeur pour initialiser les propriétés du widget.
  const CarteCrise({
    super.key, // Clé unique pour le widget, bonne pratique en Flutter.
    required this.title, // `required` signifie que cette propriété doit être fournie.
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.subtitleIcon, // Propriété optionnelle.
    this.subtitleIconColor, // Propriété optionnelle.
  });

  @override
  Widget build(BuildContext context) {
    // `Card` est un conteneur avec une ombre et des coins arrondis, style Material Design.
    return Card(
      elevation: 2, // Hauteur de l'ombre.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Coins arrondis.
      // `Padding` ajoute une marge à l'intérieur de la carte.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // `Column` organise le contenu de la carte verticalement.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligne les enfants à gauche.
          children: [
            // `Row` pour la première ligne (icône et titre).
            Row(children: [
              Icon(icon, color: iconColor), // Affiche l'icône principale.
              const SizedBox(width: 8), // Espace horizontal.
              // `Expanded` permet au titre de prendre toute la place restante pour éviter les débordements.
              Expanded(child: Text(title, style: const TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 16), // Espace vertical.
            // Affiche la valeur principale avec un style de texte plus grand et en gras.
            Text(value, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // `Row` pour la dernière ligne (icône de sous-titre et sous-titre).
            Row(children: [
              // `if` conditionnel : n'affiche l'icône que si `subtitleIcon` n'est pas nul.
              if (subtitleIcon != null) ...[
                Icon(subtitleIcon, color: subtitleIconColor, size: 18),
                const SizedBox(width: 4),
              ],
              // `Expanded` pour que le sous-titre puisse prendre la place restante.
              Expanded(child: Text(subtitle, style: TextStyle(color: subtitleIcon != null ? subtitleIconColor : Colors.grey), overflow: TextOverflow.ellipsis)),
            ]),
          ],
        ),
      ),
    );
  }
}

// Widget pour le graphique en barres de la tendance sur 6 mois.
class GraphiqueCrisesMensuel extends StatelessWidget {
  const GraphiqueCrisesMensuel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Étire les enfants sur toute la largeur.
          children: [
            Text('Tendance sur 6 mois', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            // `SizedBox` avec une hauteur fixe pour contraindre la taille du graphique.
            SizedBox(
              height: 150,
              // `BarChart` est le widget principal du package `fl_chart` pour les graphiques en barres.
              child: BarChart(
                BarChartData(
                   alignment: BarChartAlignment.spaceAround, // Espacement des barres.
                  maxY: 8, // Valeur maximale pour l'axe Y.
                  barTouchData: BarTouchData(enabled: false), // Désactive les interactions tactiles sur les barres.
                  // `titlesData` configure les titres des axes (X et Y).
                  titlesData: FlTitlesData(
                    show: true, // Affiche les titres.
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Cache les titres du haut.
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Cache les titres de droite.
                    // Configure les titres du bas (les mois).
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getBottomTitles, reservedSize: 38)),
                    // Configure les titres de gauche (les nombres).
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 2, getTitlesWidget: getLeftTitles)),
                  ),
                  // `gridData` configure les lignes de la grille en arrière-plan.
                  gridData: FlGridData(
                    show: true, // Affiche la grille.
                    drawVerticalLine: false, // Cache les lignes verticales.
                    horizontalInterval: 2, // Intervalle pour les lignes horizontales.
                    getDrawingHorizontalLine: (value) => const FlLine(color: Colors.black12, strokeWidth: 1, dashArray: [5, 5]), // Style pointillé.
                  ),
                  // `borderData` configure les bordures du graphique.
                  borderData: FlBorderData(show: true, border: Border(bottom: BorderSide(color: Colors.grey.shade300), left: BorderSide(color: Colors.grey.shade300))),
                  // `barGroups` fournit les données réelles à afficher sous forme de barres.
                  barGroups: getBarGroups(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction qui retourne la liste des données pour les barres du graphique.
  List<BarChartGroupData> getBarGroups() {
    // Les données sont fixes pour cet exemple.
    return [
      makeGroupData(0, 5), // Juin
      makeGroupData(1, 4), // Juil
      makeGroupData(2, 6), // Août
      makeGroupData(3, 5), // Sept
      makeGroupData(4, 3), // Oct
      makeGroupData(5, 0), // Nov
    ];
  }

  // Fonction utilitaire pour créer un groupe de barres (ici, une seule barre par groupe).
  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x, // Position sur l'axe X.
      barRods: [ // Liste des barres pour cette position (ici une seule).
        BarChartRodData(
          toY: y, // Hauteur de la barre.
          color: Colors.orange, // Couleur de la barre.
          width: 22, // Largeur de la barre.
          borderRadius: BorderRadius.circular(4), // Coins arrondis pour la barre.
        ),
      ],
    );
  }

  // Fonction qui génère le widget pour chaque titre de l'axe du bas (X).
  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);
    String text;
    switch (value.toInt()) {
      case 0: text = 'Juin'; break;
      case 1: text = 'Juil'; break;
      case 2: text = 'Août'; break;
      case 3: text = 'Sept'; break;
      case 4: text = 'Oct'; break;
      case 5: text = 'Nov'; break;
      default: text = ''; break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
  }

  // Fonction qui génère le widget pour chaque titre de l'axe de gauche (Y).
  Widget getLeftTitles(double value, TitleMeta meta) {
    // Affiche seulement les nombres pairs pour ne pas surcharger l'axe.
    if (value == 0 || value == 2 || value == 4 || value == 6 || value == 8) {
      return Text(
        value.toInt().toString(),
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
        textAlign: TextAlign.left,
      );
    }
    return const SizedBox.shrink(); // Retourne un widget vide pour les autres valeurs.
  }
}

// Widget pour la carte des patterns d'IA détectés.
class PatternsDetectesCard extends StatelessWidget {
  const PatternsDetectesCard({super.key});

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
            Row(
              children: [
                Icon(Icons.smart_toy_outlined, color: Colors.blue.shade800), // Icône de robot.
                const SizedBox(width: 8),
                Text('Patterns détectés', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text('Vos crises surviennent souvent :', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            // Appelle une fonction privée pour créer chaque ligne de la liste des patterns.
            _buildPatternItem('60% après exercice physique'),
            const SizedBox(height: 8),
            _buildPatternItem('30% exposition pollen élevé'),
            const SizedBox(height: 8),
            _buildPatternItem('Principalement entre 22h-6h'),
          ],
        ),
      ),
    );
  }

  // Fonction privée pour construire une ligne de pattern (icône point + texte).
  Widget _buildPatternItem(String text) {
    return Row(
      children: [
        const Icon(Icons.circle, color: Colors.orange, size: 12), // Le point orange.
        const SizedBox(width: 8),
        Text(text), // Le texte du pattern.
      ],
    );
  }
}

// Widget pour afficher un item individuel de l'historique des crises.
class HistoriqueCriseItem extends StatelessWidget {
  // Propriétés pour rendre le widget dynamique et réutilisable.
  final String date;
  final String duree;
  final String spo2;
  final String facteur;
  final String severite;

  // Constructeur qui requiert toutes les propriétés.
  const HistoriqueCriseItem({
    super.key,
    required this.date,
    required this.duree,
    required this.spo2,
    required this.facteur,
    required this.severite,
  });

  @override
  Widget build(BuildContext context) {
    // Déclare des variables pour les couleurs du badge de sévérité, qui seront déterminées dynamiquement.
    final Color severiteColor;
    final Color severiteBackgroundColor;

    // `switch` pour choisir les couleurs en fonction de la valeur de la `severite`.
    switch (severite) {
      case 'légère':
        severiteColor = Colors.yellow.shade800;
        severiteBackgroundColor = Colors.yellow.shade100;
        break;
      case 'modérée':
        severiteColor = Colors.orange.shade800;
        severiteBackgroundColor = Colors.orange.shade100;
        break;
      default: // Cas par défaut si la sévérité n'est ni 'légère' ni 'modérée'.
        severiteColor = Colors.grey.shade800;
        severiteBackgroundColor = Colors.grey.shade100;
    }

    // `Card` est le conteneur principal de l'item, avec une ombre et des coins arrondis.
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // `Column` organise le contenu de la carte verticalement.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligne les enfants à gauche.
          children: [
            // `Row` pour la ligne supérieure (date et badge de sévérité).
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Met de l'espace entre la date et le badge pour les pousser aux extrémités.
              children: [
                // `Column` pour regrouper la date et la durée l'une sous l'autre.
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Durée: $duree', style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
                // `Chip` est un petit badge, parfait pour afficher la sévérité de manière concise.
                Chip(
                  label: Text(severite),
                  backgroundColor: severiteBackgroundColor, // Applique la couleur de fond dynamique.
                  labelStyle: TextStyle(color: severiteColor, fontWeight: FontWeight.bold), // Applique la couleur de texte dynamique.
                  padding: EdgeInsets.zero, // Réduit le padding interne du chip.
                ),
              ],
            ),
            const SizedBox(height: 24), // Espace vertical important.
            // `Row` pour les deux boîtes d'information (SpO2 et Facteur).
            Row(
              children: [
                // `Expanded` garantit que chaque boîte prend la moitié de la largeur disponible.
                Expanded(child: _buildInfoBox('SpO2 minimum', spo2)),
                const SizedBox(width: 16), // Espace entre les deux boîtes.
                Expanded(child: _buildInfoBox('Facteur', facteur)),
              ],
            ),
            const SizedBox(height: 16), // Espace.
            // Affiche un autre `Chip` pour le facteur, en bas de la carte, pour un rappel visuel.
            Chip(
              label: Text(facteur),
              backgroundColor: Colors.grey.shade200,
            ),
          ],
        ),
      ),
    );
  }

  // Fonction privée et réutilisable pour construire une boîte d'information grise (SpO2, Facteur).
  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12), // Marge intérieure.
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Fond gris clair.
        borderRadius: BorderRadius.circular(8), // Coins arrondis.
      ),
      // `Column` pour afficher le label au-dessus de la valeur.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)), // Le label en petit et gris.
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), // La valeur en plus grand et en gras.
        ],
      ),
    );
  }
}

// Widget pour la vue calendrier affichée à la fin de la page.
class VueCalendrier extends StatelessWidget {
  const VueCalendrier({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste fixe de jours avec des crises pour cet exemple. Dans une vraie application, ces données seraient dynamiques.
    final joursDeCrise = [5, 12, 20];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vue calendrier - Novembre', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Affiche les en-têtes des jours de la semaine (L, M, M, etc.).
            _buildDayHeaders(),
            const SizedBox(height: 8),
            // `GridView.builder` crée une grille de manière performante, en ne construisant que les éléments visibles.
            GridView.builder(
              shrinkWrap: true, // Demande à la grille de prendre seulement la hauteur nécessaire à son contenu.
              physics: const NeverScrollableScrollPhysics(), // Désactive le défilement propre à la grille (car la page entière défile déjà).
              // Définit une grille avec un nombre fixe de 7 colonnes.
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemCount: 30, // Nombre total d'éléments dans la grille (30 jours pour Novembre).
              // `itemBuilder` est une fonction qui construit chaque cellule de la grille.
              itemBuilder: (context, index) {
                final day = index + 1; // Calcule le jour du mois (de 1 à 30).
                final hasCrisis = joursDeCrise.contains(day); // Vérifie si le jour actuel est dans la liste des jours de crise.
                // Construit la cellule pour ce jour en appelant une fonction d'aide.
                return _buildDayCell(day, hasCrisis);
              },
            ),
            const SizedBox(height: 16),
            // Affiche la légende en bas du calendrier.
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  // Fonction privée pour construire la ligne des en-têtes des jours de la semaine.
  Widget _buildDayHeaders() {
    const jours = ['L', 'M', 'M', 'J', 'V', 'S', 'D']; // Liste des jours.
    // `Row` pour aligner les textes horizontalement.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Espace équitablement les jours.
      // `map` transforme chaque chaîne de la liste `jours` en un widget `Text`.
      children: jours.map((jour) => Text(jour, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))).toList(),
    );
  }

  // Fonction privée pour construire une seule cellule de jour dans le calendrier.
  Widget _buildDayCell(int day, bool hasCrisis) {
    // `Container` pour créer la cellule carrée avec une couleur de fond et des coins arrondis.
    return Container(
      margin: const EdgeInsets.all(4), // Marge autour de chaque cellule.
      decoration: BoxDecoration(
        color: hasCrisis ? Colors.red.shade100 : Colors.green.shade100, // Couleur de fond rouge si `hasCrisis` est vrai, sinon verte.
        borderRadius: BorderRadius.circular(8), // Coins arrondis.
      ),
      // `Center` pour centrer le numéro du jour dans la cellule.
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, color: hasCrisis ? Colors.red.shade800 : Colors.green.shade800), // Couleur du texte plus foncée et dépendante de `hasCrisis`.
        ),
      ),
    );
  }

  // Fonction privée pour construire la légende (Normal / Crise) en bas du calendrier.
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centre la légende horizontalement.
      children: [
        _buildLegendItem(Colors.green.shade100, 'Normal'),
        const SizedBox(width: 24), // Espace entre les deux items de la légende.
        _buildLegendItem(Colors.red.shade100, 'Crise'),
      ],
    );
  }

  // Fonction privée pour un item de la légende (un carré de couleur + un texte).
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color), // Le petit carré de couleur.
        const SizedBox(width: 8),
        Text(text), // Le texte explicatif.
      ],
    );
  }
}