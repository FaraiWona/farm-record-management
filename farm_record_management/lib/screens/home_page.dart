import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crop.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farm Management App',
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
        child: SingleChildScrollView(child: CropDetailsForm()),
      ),
    );
  }
}

class CropDetailsForm extends StatefulWidget {
  const CropDetailsForm({super.key});

  @override
  _CropDetailsFormState createState() => _CropDetailsFormState();
}

class _CropDetailsFormState extends State<CropDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _plantingDateController = TextEditingController();
  final TextEditingController _harvestDateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final CollectionReference _cropsCollection =
      FirebaseFirestore.instance.collection('crops');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextFormField(_nameController, 'Crop Name', false),
          const SizedBox(height: 16),
          _buildTextFormField(
              _plantingDateController, 'Planting Date (YYYY-MM-DD)', false),
          const SizedBox(height: 16),
          _buildTextFormField(
              _harvestDateController, 'Harvest Date (YYYY-MM-DD)', false),
          const SizedBox(height: 16),
          _buildTextFormField(_quantityController, 'Quantity', true),
          const SizedBox(height: 16),
          _buildTextFormField(_notesController, 'Notes', false, maxLines: 3),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Background color
              foregroundColor: Colors.white, // Text color
              padding:
                  const EdgeInsets.symmetric(vertical: 12), // Button padding
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
