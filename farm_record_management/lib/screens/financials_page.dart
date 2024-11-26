import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextFormField(
              _transactionTypeController, 'Transaction Type', false),
          const SizedBox(height: 16),
          _buildTextFormField(_amountController, 'Amount', true),
          const SizedBox(height: 16),
          _buildTextFormField(_dateController, 'Date (YYYY-MM-DD)', false),
          const SizedBox(height: 16),
          _buildTextFormField(_descriptionController, 'Description', false),
          const SizedBox(height: 16),
          _buildTextFormField(_notesController, 'Notes', false, maxLines: 3),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextFormField(
      TextEditingController controller, String label, bool isNumeric,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the $label';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final financialDetails = {
        'transactionType': _transactionTypeController.text,
        'amount': _amountController.text,
        'date': _dateController.text,
        'description': _descriptionController.text,
        'notes': _notesController.text,
        "userId": FirebaseAuth.instance.currentUser!.uid
      };

      _financialsCollection.add(financialDetails).then((value) {
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CropListPage()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add transaction: $error')),
        );
      });
    }
  }

  @override
  void dispose() {
    _transactionTypeController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
