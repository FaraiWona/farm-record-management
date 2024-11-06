import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCropPage extends StatelessWidget {
  final String cropId;
  final String cropName;
  final String plantingDate;
  final String harvestDate;
  final String quantity;
  final String notes;


  const UpdateCropPage({
    super.key,
    required this.cropId,
    required this.cropName,
    required this.plantingDate,
    required this.harvestDate,
    required this.quantity,
    required this.notes,
  });

 @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: cropName);
    final TextEditingController plantingDateController =
        TextEditingController(text: plantingDate);
    final TextEditingController harvestDateController =
        TextEditingController(text: harvestDate);
    final TextEditingController quantityController =
        TextEditingController(text: quantity);
    final TextEditingController notesController =
        TextEditingController(text: notes);

 return Scaffold(
      appBar: AppBar(
        title: const Text('Update Crop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Crop Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the crop name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: plantingDateController,
                decoration: const InputDecoration(
                  labelText: 'Planting Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the planting date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: harvestDateController,
                decoration: const InputDecoration(
                  labelText: 'Harvest Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the harvest date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
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