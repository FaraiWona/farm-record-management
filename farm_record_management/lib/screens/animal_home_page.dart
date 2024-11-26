import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crop.dart';

class AnimalHomePage extends StatelessWidget {
  const AnimalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farm Animals',
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
        child: SingleChildScrollView(child: AnimalDetailsForm()),
      ),
    );
  }
}

class AnimalDetailsForm extends StatefulWidget {
  const AnimalDetailsForm({super.key});

  @override
  _AnimalDetailsFormState createState() => _AnimalDetailsFormState();
}

class _AnimalDetailsFormState extends State<AnimalDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _healthStatusController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final CollectionReference _animalsCollection =
      FirebaseFirestore.instance.collection('animals');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextFormField(
              _birthDateController, 'Birth Date (YYYY-MM-DD)', false),
          const SizedBox(height: 16),
          _buildTextFormField(_breedController, 'Breed', false),
          const SizedBox(height: 16),
          _buildTextFormField(_healthStatusController, 'Health Status', false),
          const SizedBox(height: 16),
          _buildTextFormField(_speciesController, 'Species', false),
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
      final animalDetails = {
        'birthDate': _birthDateController.text,
        'breed': _breedController.text,
        'healthStatus': _healthStatusController.text,
        'species': _speciesController.text,
        'notes': _notesController.text,
        'userId': FirebaseAuth.instance.currentUser!.uid,
      };

      _animalsCollection.add(animalDetails).then((value) {
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal added successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CropListPage()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add animal: $error')),
        );
      });
    }
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    _breedController.dispose();
    _healthStatusController.dispose();
    _speciesController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
