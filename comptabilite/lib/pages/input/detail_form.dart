
import 'package:flutter/material.dart';

import 'package:comptabilite/controllers/input_controller.dart';

@immutable
// ignore: must_be_immutable
class DetailForm extends StatefulWidget {
  String? month;
  String? year;
  String? idr;
  String? libelle;

  DetailForm({
    super.key,
    this.month,
    this.year,
    this.idr,
    this.libelle,
  });

  @override
  State<DetailForm> createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  final InputController ip = InputController();
  
  int index = 0;
  List<dynamic> accountList = [];
  final List<String> months = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre'
  ];
  final List<dynamic> operations = [
    { 'libelle' : 'Débit', "value" : "1"},
    { 'libelle' : 'Crédit', "value" : "0" },
  ];

  String? selectedAccount;
  String? selectedreference;
  String? selectedamount;
  String? selectedoperation;

  
  final TextEditingController _referencecontroller = TextEditingController();
  final TextEditingController _amountcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    index = int.tryParse(widget.month.toString()) ?? 0;
    _loadAccountList();
  }

  Future<void> _loadAccountList() async {
    List<dynamic> accounts = await ip.accounts();
    setState(() {
      accountList = accounts;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saisie : ${widget.libelle} de ${months[index-1]} ${widget.year} (Etape 2/2)',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            width: 600,
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
                  'Contenue de la saisie pour l\'opération ${widget.libelle} du ${months[index-1]} ${widget.year}.',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                _gap(),
                _gap(),

                // Search Field Plan Comptable
                SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText : 'Compte',
                        hintText: 'Tapez le numero de compte ou l\'intitulé de compte',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.teal),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onTap: () {
                        controller.openView();
                      },
                    );
                  },
                  suggestionsBuilder: (BuildContext context, SearchController controller) {
                    final query = controller.text.toLowerCase();
                    
                    // CORRECTION : Filtrer la liste basée sur la requête
                    final filteredAccounts = accountList.where((account) {
                      final numero = account['numero']?.toString() ?? '';
                      final libelle = account['libelle']?.toString() ?? '';
                      final searchableText = '$numero $libelle'.toLowerCase();
                      return searchableText.contains(query);
                    }).toList();

                    // CORRECTION : Utiliser filteredAccounts au lieu de accountList
                    return filteredAccounts.map((account) {
                      final numero = account['numero']?.toString() ?? '';
                      final libelle = account['libelle']?.toString() ?? '';
                      
                      return ListTile(
                        title: Text('$numero $libelle'),
                        onTap: () {
                          setState(() {
                            selectedAccount = account['idpc']?.toString() ?? '';
                            controller.closeView('$numero $libelle');
                          });
                        },
                      );
                    }).toList();
                  },
                ),
                _gap(),

                // Textfield Reference
                SizedBox(
                  width: 600,
                  child: TextField(
                    controller: _referencecontroller,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 8, 41, 38),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Référence',
                      prefixIcon:
                          const Icon(Icons.calendar_today, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // TextField Montant
                SizedBox(
                  width: 600,
                  child: TextFormField(
                    controller: _amountcontroller,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 8, 41, 38),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Montant',
                      hintText: '0.00',
                      prefixIcon:
                          const Icon(Icons.numbers, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    
                  ),
                ),
                const SizedBox(height: 24),            

                // Dropdown Operation (Debit/Credit)
                SizedBox(
                  width: 600,
                  child: DropdownButtonFormField<String>(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 8, 41, 38),
                    ),
                    value: selectedoperation,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Type d\'opération de saisie',
                      prefixIcon:
                          const Icon(Icons.view_list, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: operations.map<DropdownMenuItem<String>>((rapport) {
                      final map = rapport as Map<String, dynamic>;
                      return DropdownMenuItem<String>(
                        value: map['value'].toString(),
                        child: Text(map['libelle'].toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedoperation = value;
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
                    label: const Text('Valider', style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255)
                      )
                    ),
                    onPressed: () {
                      selectedreference = _referencecontroller.text;
                      selectedamount = _amountcontroller.text;
                      _handleDateForm(context, selectedAccount, selectedreference, selectedamount, selectedoperation);
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

  Future<void> _handleDateForm(BuildContext context, String? compte, String? reference, String? amount, String? operation) async {
    bool error = false;
    String? messages;
    if (compte == null || amount == null || operation == null) {
      debugPrint('compte: $compte, reference: $reference, montant: $amount, operation: $operation');
      messages = "Les champs le compte, le montant, et le type d'opération (débit ou crédit) sont obligatoires";
    }else{            
      final normalizedValue = amount.replaceAll(',', '.');
                      
      if (double.tryParse(normalizedValue) == null) {
        error = true;
        messages = "Le champ 'Montant' doit etre un nombre.";
      }else{
        await ip.simulation(context, compte, reference, normalizedValue, operation);
      }
    }

    if(error){
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text.rich(
            TextSpan(
                text: messages,
                style: TextStyle(color: Colors.white),
              ),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
    }
  }


}