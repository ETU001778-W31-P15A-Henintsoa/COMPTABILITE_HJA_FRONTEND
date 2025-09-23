import 'package:flutter/material.dart';

import '../../controllers/input_controller.dart';

class DateForm extends StatefulWidget {
  const DateForm({super.key});

  @override
  State<DateForm> createState() => _DateFormState();
}

class _DateFormState extends State<DateForm> {
  final InputController ip = InputController(); 
  List<dynamic> rapports = [];

  String? selectedMonth;
  String? selectedYear;
  String? selectedRapport;
  String? libelleRapport;
  
  // Liste de Map pour afficher le texte mais stocker la valeur numérique
  final List<Map<String, String>> months = [
    {'name': 'Janvier', 'value': '1'},
    {'name': 'Février', 'value': '2'},
    {'name': 'Mars', 'value': '3'},
    {'name': 'Avril', 'value': '4'},
    {'name': 'Mai', 'value': '5'},
    {'name': 'Juin', 'value': '6'},
    {'name': 'Juillet', 'value': '7'},
    {'name': 'Août', 'value': '8'},
    {'name': 'Septembre', 'value': '9'},
    {'name': 'Octobre', 'value': '10'},
    {'name': 'Novembre', 'value': '11'},
    {'name': 'Décembre', 'value': '12'},
  ];

  final List<String> years = List.generate(50, (index) => (2025 - index).toString());

  @override
  void initState() {
    super.initState();
    _loadRapports();
  }

  Future<void> _loadRapports() async {
    List<dynamic> data = await ip.rapports();
    
    setState(() {
      rapports = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saisie d\'opérations',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topCenter, // Centré horizontalement seulement
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            width: 600, // Largeur fixe pour le formulaire
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.teal.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                // Titre
                  Text(
                    'Paramètres 1',
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 2, 2, 2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                _gap(),
                _gap(),

                // Dropdown mois
                SizedBox(
                  width: 600,
                  child: DropdownButtonFormField<String>(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 8, 41, 38),
                    ),
                    value: selectedMonth,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Mois',
                      prefixIcon:
                          const Icon(Icons.calendar_today, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: months.map((month) {
                      return DropdownMenuItem(
                        value: month['value'],
                        child: Text(month['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Dropdown année
                SizedBox(
                  width: 600,
                  child: DropdownButtonFormField<String>(
                    focusColor: Color.fromARGB(255, 190, 196, 195),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 8, 41, 38),
                    ),
                    value: selectedYear,
                    decoration: InputDecoration(
                      labelText: 'Année',
                      prefixIcon: const Icon(Icons.calendar_view_day,
                          color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: years.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Dropdown rapports
                SizedBox(
                  width: 600,
                  child: DropdownButtonFormField<String>(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 8, 41, 38),
                    ),
                    value: selectedRapport,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Type d\'opération de saisie',
                      prefixIcon:
                          const Icon(Icons.view_list, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: rapports.map<DropdownMenuItem<String>>((rapport) {
                      final map = rapport as Map<String, dynamic>;
                      return DropdownMenuItem<String>(
                        value: map['idr'].toString(),
                        child: Text("${map['notation']} - ${map['libelle']}"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRapport = value;
                        libelleRapport = "${rapports.firstWhere((rapport) => rapport['idr'].toString() == value)['notation'].toString()} (${rapports.firstWhere((rapport) => rapport['idr'].toString() == value)['libelle'].toString()})";
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Bouton Submit
                SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: const Text('Continuer', style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255)
                      )
                    ),
                    onPressed: () {
                      _handleDateForm(selectedMonth, selectedYear, selectedRapport, libelleRapport, context);
                    },
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _gap() => const SizedBox(height: 16);

  Future<void> _handleDateForm(String? month, String? year, String? rapport, String? libelle, BuildContext context) async {
    if (month == null || year == null || rapport == null) {
      setState(() {
        debugPrint('month: $month, year: $year, rapport: $rapport');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text.rich(
            TextSpan(
                text: "Veuillez sélectionner le mois, l'année et le type d'opération de saisie",
                style: TextStyle(color: Colors.white),
              ),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
    }else{
      String? m = month;
      String? y = year;
      String? idr = rapport;

      await ip.stockDateInput(m, y, idr, libelle, context);
    }
  }

}