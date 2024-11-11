import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crop.dart';
class FinancialsPage extends StatelessWidget {
  const FinancialsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farm Financials',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
              IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CropListPage()),
              );
            },
          ),
        ],
      ),
       body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: FinancialDetailsForm()),
      ),
    );
  }
}

class FinancialDetailsForm extends StatefulWidget {
  const FinancialDetailsForm({super.key});

  @override
  _FinancialDetailsFormState createState() => _FinancialDetailsFormState();
}

class _FinancialDetailsFormState extends State<FinancialDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _transactionTypeController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final CollectionReference _financialsCollection =
      FirebaseFirestore.instance.collection('financials');