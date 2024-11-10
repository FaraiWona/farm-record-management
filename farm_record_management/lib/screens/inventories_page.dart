import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crop.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory Management App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const CropListPage()), // Navigate back to CropListPage
              );
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: InventoryDetailsForm()),
      ),
    );
  }
}
class InventoryDetailsForm extends StatefulWidget {
  const InventoryDetailsForm({super.key});

  @override
  _InventoryDetailsFormState createState() => _InventoryDetailsFormState();
}

class _InventoryDetailsFormState extends State<InventoryDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final CollectionReference _inventoryCollection =
      FirebaseFirestore.instance.collection('inventories');



