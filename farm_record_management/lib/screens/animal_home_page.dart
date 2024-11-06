import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnimalHomePage extends StatelessWidget {
  const AnimalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farm Management App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the Animal Management App!',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Manage your animals efficiently.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 40),
              AnimalDetailsForm(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // will add later
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
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
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();

 
  final CollectionReference _animalsCollection =
      FirebaseFirestore.instance.collection('animals');

 @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _birthDateController,
            decoration: const InputDecoration(
              labelText: 'Birth Date (YYYY-MM-DD)',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the birth date';
              }
              return null;
            },
          ),      