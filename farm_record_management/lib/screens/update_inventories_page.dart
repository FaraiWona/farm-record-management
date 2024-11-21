import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateInventoryPage extends StatelessWidget {
  final String inventoryId;
  final String item;
  final String quantity;
  final String purchaseDate;
  final String notes;

  const UpdateInventoryPage({
    super.key,
    required this.inventoryId,
    required this.item,
    required this.quantity,
    required this.purchaseDate,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController itemController =
        TextEditingController(text: item);
    final TextEditingController quantityController =
        TextEditingController(text: quantity);
    final TextEditingController purchaseDateController =
        TextEditingController(text: purchaseDate);
    final TextEditingController notesController =
        TextEditingController(text: notes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Inventory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: itemController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
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
                controller: purchaseDateController,
                decoration: const InputDecoration(
                  labelText: 'Purchase Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the purchase date';
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
                    final updatedInventory = {
                      'item': itemController.text,
                      'quantity': quantityController.text,
                      'purchaseDate': purchaseDateController.text,
                      'notes': notesController.text,
                    };

                    // Update the inventory document in Firestore
                    FirebaseFirestore.instance
                        .collection('inventories')
                        .doc(inventoryId)
                        .update(updatedInventory)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Inventory updated successfully!')),
                      );
                      Navigator.pop(context); // Navigate back to previous page
                    }).catchError((error) {
                      print("Failed to update inventory: $error");
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
