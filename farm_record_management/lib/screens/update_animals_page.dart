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