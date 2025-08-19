import 'package:flutter/material.dart';

class DateForm extends StatefulWidget {
  const DateForm({super.key});

  @override
  State<DateForm> createState() => _DateFormState();
}

class _DateFormState extends State<DateForm> {
  // final _formKey = GlobalKey<FormState>();
  // final TextEditingController _monthController = TextEditingController();
  // final TextEditingController _yearController = TextEditingController();

  String? selectedMonth;
  String? selectedYear;

  final List<String> months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];


  final List<String> years = List.generate(50, (index) => (2025 - index).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Month & Year Form'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dropdown mois
              DropdownButtonFormField<String>(
                style: const TextStyle(
                  color: Color.fromARGB(255, 8, 41, 38), // couleur du texte
                ),
                value: selectedMonth,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Month',
                  prefixIcon: const Icon(Icons.calendar_today, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: months.map((month) {
                  return DropdownMenuItem(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a month' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown année
              DropdownButtonFormField<String>(
                style: const TextStyle(
                  color: Color.fromARGB(255, 8, 41, 38), // couleur du texte
                ),
                value: selectedYear,
                decoration: InputDecoration(
                  labelText: 'Year',
                  prefixIcon: const Icon(Icons.calendar_view_day, color: Colors.teal),
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
                validator: (value) => value == null ? 'Please select a year' : null,
              ),
              const SizedBox(height: 24),

              // Bouton Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.send),
                  label: const Text('Submit', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    if (selectedMonth != null && selectedYear != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Month: $selectedMonth, Year: $selectedYear')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select both month and year')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}