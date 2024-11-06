import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateAnimalPage extends StatelessWidget {
   final String animalId;
  final String birthDate;
  final String breed;
  final String healthStatus;
  final String species;
  final String notes;

const UpdateAnimalPage({
    super.key,
    required this.animalId,
    required this.birthDate,
    required this.breed,
    required this.healthStatus,
    required this.species,
    required this.notes,
  });
 @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController birthDateController =
        TextEditingController(text: birthDate);
    final TextEditingController breedController =
        TextEditingController(text: breed);
    final TextEditingController healthStatusController =
        TextEditingController(text: healthStatus);
    final TextEditingController speciesController =
        TextEditingController(text: species);
    final TextEditingController notesController =
        TextEditingController(text: notes);

return Scaffold(
      appBar: AppBar(
        title: const Text('Update Animal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: birthDateController,
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
              const SizedBox(height: 16),
              TextFormField(
                controller: breedController,
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the breed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: healthStatusController,
                decoration: const InputDecoration(
                  labelText: 'Health Status',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the health status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: speciesController,
                decoration: const InputDecoration(
                  labelText: 'Species',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the species';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final updatedAnimal = {
                      'birthDate': birthDateController.text,
                      'breed': breedController.text,
                      'healthStatus': healthStatusController.text,
                      'species': speciesController.text,
                      'notes': notesController.text,
                    };
