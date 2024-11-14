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
