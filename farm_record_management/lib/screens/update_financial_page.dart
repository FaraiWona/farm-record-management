import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateFinancialsPage extends StatefulWidget {
  final String financialId;
  final String transactionType;
  final String amount;
  final String date;
  final String description;
  final String notes;

  const UpdateFinancialsPage({
    super.key,
    required this.financialId,
    required this.transactionType,
    required this.amount,
    required this.date,
    required this.description,
    required this.notes,
  });

  @override
  _UpdateFinancialsPageState createState() => _UpdateFinancialsPageState();
}

class _UpdateFinancialsPageState extends State<UpdateFinancialsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _transactionTypeController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _transactionTypeController.text = widget.transactionType;
    _amountController.text = widget.amount;
    _dateController.text = widget.date;
    _descriptionController.text = widget.description;
    _notesController.text = widget.notes;
  }

  void _updateFinancialDetails() {
    if (_formKey.currentState!.validate()) {
      final updatedFinancialDetails = {
        'transactionType': _transactionTypeController.text,
        'amount': _amountController.text,
        'date': _dateController.text,
        'description': _descriptionController.text,
        'notes': _notesController.text,
      };

      FirebaseFirestore.instance
          .collection('financials')
          .doc(widget.financialId)
          .update(updatedFinancialDetails)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction updated successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update transaction: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Financial Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField(
                  _transactionTypeController, 'Transaction Type'),
              const SizedBox(height: 16),
              _buildTextFormField(_amountController, 'Amount', isNumeric: true),
              const SizedBox(height: 16),
              _buildTextFormField(_dateController, 'Date (YYYY-MM-DD)'),
              const SizedBox(height: 16),
              _buildTextFormField(_descriptionController, 'Description'),
              const SizedBox(height: 16),
              _buildTextFormField(_notesController, 'Notes', maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateFinancialDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(
                      vertical: 12), // Button padding
                ),
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField(
      TextEditingController controller, String label,
      {bool isNumeric = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
