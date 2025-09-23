
// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';

import 'package:comptabilite/controllers/input_controller.dart';
import 'package:comptabilite/utils/tools.dart';

@immutable
// ignore: must_be_immutable
class DetailForm extends StatefulWidget {
  String? month;
  String? year;
  String? idr;
  String? libelle;
  String? npiece;

  DetailForm({
    super.key,
    this.month,
    this.year,
    this.idr,
    this.libelle,
    this.npiece,
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
  String? selectedlibelle;
  String? selectedamount;
  String? selectedoperation;

  int? _editingIndex;
  Map<String, String>? _editingData;

  List<Map<String, String>> entries = [];
  double totalDebit = 0.0;
  double totalCredit = 0.0;

  final TextEditingController _referencecontroller = TextEditingController();
  final TextEditingController _libellecontroller = TextEditingController();
  final TextEditingController _amountcontroller = TextEditingController();
  final SearchController _searchController = SearchController();

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
  
  void _addEntry() {
    selectedlibelle = _libellecontroller.text;
    selectedreference = _referencecontroller.text;
    selectedamount = _amountcontroller.text;

    if (selectedlibelle != null && selectedlibelle!.trim().isNotEmpty && selectedAccount != null && selectedamount != null && selectedamount!.trim().isNotEmpty && selectedoperation != null) {
      final normalizedValue = selectedamount!.replaceAll(',', '.');
      final amount = double.tryParse(normalizedValue) ?? 0.0;
      
      setState(() {
        entries.add({
          'libelle': selectedlibelle ?? '',
          'compte': selectedAccount!,
          'reference': selectedreference ?? '',
          'montant': amount.toString(),
          'operation': selectedoperation!,
        });
        
        // Mettre à jour les totaux
        if (selectedoperation == '1') { // Débit
          totalDebit += amount;
        } else { // Crédit
          totalCredit += amount;
        }
        
        // Réinitialiser les champs
        selectedlibelle = null;
        selectedAccount = null;
        selectedreference = null;
        selectedamount = null;
        selectedoperation = null;
        _searchController.clear();
        _libellecontroller.clear();
        _referencecontroller.clear();
        _amountcontroller.clear();

      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeEntry(int index) {
    setState(() {
      final entry = entries[index];
      final amount = double.parse(entry['montant']!);
      
      if (entry['operation'] == '1') {
        totalDebit -= amount;
      } else {
        totalCredit -= amount;
      }
      
      entries.removeAt(index);
    });
  }

  void _startEditingEntry(int index) {
    setState(() {
      _editingIndex = index;
      _editingData = Map<String, String>.from(entries[index]);
      
      // Pré-remplir les champs du formulaire avec les données à éditer
      selectedlibelle = _editingData!['libelle'];
      selectedAccount = _editingData!['compte'];
      selectedreference = _editingData!['reference'];
      selectedamount = _editingData!['montant'];
      selectedoperation = _editingData!['operation'];
      
      _libellecontroller.text = selectedlibelle ?? '';
      _referencecontroller.text = selectedreference ?? '';
      _amountcontroller.text = selectedamount ?? '';
      
      // Mettre à jour le SearchController avec le compte sélectionné
      if (selectedAccount != null) {
        final foundAccount = accountList.firstWhere(
          (account) => account['idpc'].toString() == selectedAccount,
          orElse: () => {},
        );
        
        if (foundAccount != null) {
          final numero = foundAccount['numero']?.toString() ?? '';
          final libelle = foundAccount['libelle']?.toString() ?? '';
          _searchController.text = '$numero $libelle';
        }
      }
    });
  }

  void _saveEditedEntry(int index) {
    selectedlibelle = _libellecontroller.text;
    selectedreference = _referencecontroller.text;
    selectedamount = _amountcontroller.text;

    if (selectedlibelle != null && selectedAccount != null && selectedamount != null && selectedoperation != null) {
      final normalizedValue = selectedamount!.replaceAll(',', '.');
      final newAmount = double.tryParse(normalizedValue) ?? 0.0;
      final oldAmount = double.parse(entries[index]['montant']!);
      final oldOperation = entries[index]['operation']!;
      
      setState(() {
        if (oldOperation == '1') {
          totalDebit -= oldAmount;
        } else {
          totalCredit -= oldAmount;
        }

        entries[index] = {
          'libelle' : selectedlibelle ?? '',
          'compte': selectedAccount!,
          'reference': selectedreference ?? '',
          'montant': newAmount.toString(),
          'operation': selectedoperation!,
        };
        
        if (selectedoperation == '1') {
          totalDebit += newAmount;
        } else {
          totalCredit += newAmount;
        }
        
        _editingIndex = null;
        _editingData = null;
        selectedlibelle = null;
        selectedAccount = null;
        selectedreference = null;
        selectedamount = null;
        selectedoperation = null;
        _libellecontroller.clear();
        _searchController.clear();
        _referencecontroller.clear();
        _amountcontroller.clear();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Modification enregistrée'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _cancelEditing() {
    setState(() {
      _editingIndex = null;
      _editingData = null;

      // Réinitialiser les champs
      selectedlibelle = null;
      selectedAccount = null;
      selectedreference = null;
      selectedamount = null;
      selectedoperation = null;
      _searchController.clear();
      _libellecontroller.clear();
      _referencecontroller.clear();
      _amountcontroller.clear();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: 'Opération sur le classeur '),
            TextSpan(
              text: widget.libelle ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' - '),
            TextSpan(
              text: months[index-1],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' '),
            TextSpan(
              text: widget.year ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
                 RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'No. Pièce :  '),
                      TextSpan(
                        text: widget.npiece ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                _gap(),
                _gap(),

                // Textfield Reference
                SizedBox(
                  width: 600,
                  child: TextField(
                    controller: _libellecontroller,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 8, 41, 38),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Libellé / Description',
                      prefixIcon:
                          const Icon(Icons.description, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // SearchField Plan Comptable
                SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Compte',
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
                  suggestionsBuilder: (BuildContext context, controller) {
                    final query = controller.text.toLowerCase();
                    
                    final filteredAccounts = accountList.where((account) {
                      final numero = account['numero']?.toString() ?? '';
                      final libelle = account['libelle']?.toString() ?? '';
                      final searchableText = '$numero $libelle'.toLowerCase();
                      return searchableText.contains(query);
                    }).toList();

                    return filteredAccounts.map((account) {
                      final numero = account['numero']?.toString() ?? '';
                      final libelle = account['libelle']?.toString() ?? '';
                      
                      return ListTile(
                        title: Text('$numero $libelle'),
                        onTap: () {
                          setState(() {
                            selectedAccount = account['idpc']?.toString() ?? '';
                            var place = '$numero $libelle';
                            _searchController.text = place;
                            controller.closeView(place);
                          });
                        },
                      );
                    }).toList();
                  },
                ),
                const SizedBox(height: 24),

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

                // Bouton pour ajouter une ligne ou annuler l'édition
                SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _editingIndex != null ? Colors.orange : Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(_editingIndex != null ? Icons.cancel : Icons.add, color: Color.fromARGB(255, 255, 255, 255),),
                    label: Text(
                      _editingIndex != null ? 'Annuler modification' : 'Ajouter une ligne',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      )
                    ),
                    onPressed: () {
                      if (_editingIndex != null) {
                        _cancelEditing();
                      } else {                     
                        _addEntry();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Affichage des totaux
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('Total Débit', style: TextStyle(fontWeight: FontWeight.bold)),
                          // ignore: unnecessary_string_interpolations
                          Text('${Tools.moneyFormat(totalDebit.toStringAsFixed(2))}', 
                               style: TextStyle(color: Colors.red, fontSize: 18)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Total Crédit', style: TextStyle(fontWeight: FontWeight.bold)),
                          // ignore: unnecessary_string_interpolations
                          Text('${Tools.moneyFormat(totalCredit.toStringAsFixed(2))}', 
                               style: TextStyle(color: Colors.blue, fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
                _gap(),

                // Afficher un message si les totaux ne sont pas équilibrés
                if ((totalDebit - totalCredit).abs() > 0.01)
                  Column(
                    children: [
                      Text(
                        'Les totaux ne sont pas équilibrés! Différence: ${Tools.moneyFormat((totalDebit - totalCredit).abs().toStringAsFixed(2))}',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      _gap(),
                    ],
                  ),
                // Liste des entrées existantes
                if (entries.isNotEmpty) ...[
                  Text('Lignes saisies:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  _gap(),
                  ...entries.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final account = accountList.firstWhere(
                      (acc) => acc['idpc'].toString() == data['compte'],
                      orElse: () => {'numero': 'N/A', 'libelle': 'Compte inconnu'},
                    );

                    final bool isEditing = _editingIndex == index;
                    
                    return Card(
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             'Saisie ${index + 1} : ${data['libelle']!}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '${account['numero']} - ${account['libelle']} : ${data['operation'] == '1' ? 'Débit' : 'Crédit'}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Référence
                            Text(
                              'Réf: ${(data['reference'] == null || data['reference']!.isEmpty) ? 'Aucune référence' : data['reference']}',
                              style: TextStyle(fontSize: 13),
                            ),
                            // Montant
                            Text(
                              'Montant: ${Tools.moneyFormat(data['montant'])}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: data['operation'] == '1' ? Colors.red : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icône de modification
                            IconButton(
                              icon: Icon(isEditing ? Icons.save : Icons.edit, 
                              color: isEditing ? Colors.green : Colors.blue),
                              onPressed: () => isEditing ? _saveEditedEntry(index) : _startEditingEntry(index),
                            ),
                            // Icône de suppression
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeEntry(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  _gap(),
                ],
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
                    label: const Text('Enregistrer', style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255)
                      )
                    ),
                    onPressed: () {
                      if ((totalDebit - totalCredit).abs() < 0.01) {
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Les totaux doivent être équilibrés avant de valider.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      Map<String, String> saisie = {
                        'mois': '${widget.month}',
                        'annee': '${widget.year}',
                        'idr' : '${widget.idr}',
                        'npiece': '${widget.npiece}',
                        'lignes': '${ entries.map((e) => {
                          'libelle' : e['libelle'],
                          'compte' : e['compte'],
                          'ref': e['reference'],
                          'montant' : e['montant'],
                          'operation' : e['operation']
                        }).toList()}'
                      };
                      _handleDateForm(context, saisie);
                    },
                  ),
                ),
                const SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  Future<void> _handleDateForm(BuildContext context, Map<String, String> data) async {
    await ip.insertInput(context, data);
  }

}