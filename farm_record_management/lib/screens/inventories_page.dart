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

 @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextFormField(_itemController, 'Item', false),
          const SizedBox(height: 16),
          _buildTextFormField(_quantityController, 'Quantity', true),
          const SizedBox(height: 16),
          _buildTextFormField(
              _purchaseDateController, 'Purchase Date (YYYY-MM-DD)', false),
          const SizedBox(height: 16),
          _buildTextFormField(_notesController, 'Notes', false, maxLines: 3),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
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
      final inventoryDetails = {
        'item': _itemController.text,
        'quantity': _quantityController.text,
        'purchaseDate': _purchaseDateController.text,
        'notes': _notesController.text,
      };

      _inventoryCollection.add(inventoryDetails).then((value) {
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inventory item added successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CropListPage()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add inventory item: $error')),
        );
      });
    }
  }
@override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    _purchaseDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

