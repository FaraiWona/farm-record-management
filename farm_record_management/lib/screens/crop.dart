import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'update_crop_page.dart';
import 'home_page.dart';
import 'animal_home_page.dart';
import 'update_animals_page.dart';
import 'inventories_page.dart';
import 'update_inventories_page.dart';
import 'financials_page.dart';
import 'update_financial_page.dart';

class CropListPage extends StatelessWidget {
  const CropListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farm Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Navigation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            _buildDrawerListTile(context, 'Manage Crops', const HomePage()),
            _buildDrawerListTile(
                context, 'Manage Animals', const AnimalHomePage()),
            _buildDrawerListTile(
                context, 'Manage Inventories', const InventoryPage()),
            _buildDrawerListTile(
                context, 'Manage Financials', const FinancialsPage()),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              _buildSectionWithShadow(_buildCropsSection(), 'Crops'),
              _buildDivider(),
              _buildSectionWithShadow(_buildAnimalsSection(), 'Animals'),
              _buildDivider(),
              _buildSectionWithShadow(_buildInventorySection(), 'Inventories'),
              _buildDivider(),
              _buildSectionWithShadow(_buildFinancialsSection(), 'Financials'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the drawer tiles
  Widget _buildDrawerListTile(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  // Method to add shadow behind the sections
  Widget _buildSectionWithShadow(Widget child, String sectionTitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(sectionTitle, style: const TextStyle(fontSize: 20)),
        children: [child],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      height: 1,
      thickness: 1,
    );
  }

  Widget _buildFinancialsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('financials').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final financials = snapshot.data!.docs;

        if (financials.isEmpty) {
          return const Center(
            child: Text(
              'No financial transactions available. Add some to get started!',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        return Column(
          children: financials.map((financial) {
            final financialData = financial.data() as Map<String, dynamic>;
            final financialId = financial.id;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Transaction Type: ${financialData['transactionType']}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Amount: ${financialData['amount']}'),
                    Text('Date: ${financialData['date']}'),
                    Text('Description: ${financialData['description']}'),
                    Text('Notes: ${financialData['notes'] ?? 'No notes'}'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('financials')
                                .doc(financialId)
                                .delete()
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Transaction deleted successfully!')));
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Failed to delete transaction: $error')));
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateFinancialsPage(
                                  financialId: financialId,
                                  transactionType:
                                      financialData['transactionType'],
                                  amount: financialData['amount'],
                                  date: financialData['date'],
                                  description: financialData['description'],
                                  notes: financialData['notes'] ?? '',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildInventorySection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('inventories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final inventories = snapshot.data!.docs;

        if (inventories.isEmpty) {
          return const Center(
            child: Text(
              'No inventory items available. Add some to get started!',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        return Column(
          children: inventories.map((inventory) {
            final inventoryData = inventory.data() as Map<String, dynamic>;
            final inventoryId = inventory.id;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Item: ${inventoryData['item']}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Quantity: ${inventoryData['quantity']}'),
                    Text('Purchase Date: ${inventoryData['purchaseDate']}'),
                    Text('Notes: ${inventoryData['notes'] ?? 'No notes'}'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('inventories')
                                .doc(inventoryId)
                                .delete()
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Inventory item deleted successfully!')));
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Failed to delete inventory item: $error')));
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateInventoryPage(
                                  inventoryId: inventoryId,
                                  item: inventoryData['item'],
                                  quantity: inventoryData['quantity'],
                                  purchaseDate: inventoryData['purchaseDate'],
                                  notes: inventoryData['notes'] ?? '',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCropsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('crops').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final crops = snapshot.data!.docs;

        if (crops.isEmpty) {
          return const Center(
            child: Text(
              'No crops available. Add some to get started!',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        return Column(
          children: crops.map((crop) {
            final cropData = crop.data() as Map<String, dynamic>;
            final cropId = crop.id;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Crop Name: ${cropData['name']}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Planting Date: ${cropData['plantingDate']}'),
                    Text('Harvest Date: ${cropData['harvestDate']}'),
                    Text('Quantity: ${cropData['quantity']}'),
                    Text('Notes: ${cropData['notes'] ?? 'No notes'}'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('crops')
                                .doc(cropId)
                                .delete()
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Crop deleted successfully!')));
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to delete crop: $error')));
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateCropPage(
                                  cropId: cropId,
                                  cropName: cropData['name'],
                                  plantingDate: cropData['plantingDate'],
                                  harvestDate: cropData['harvestDate'],
                                  quantity: cropData['quantity'],
                                  notes: cropData['notes'] ?? '',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAnimalsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('animals').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final animals = snapshot.data!.docs;

        if (animals.isEmpty) {
          return const Center(
            child: Text(
              'No animals available. Add some to get started!',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        return Column(
          children: animals.map((animal) {
            final animalData = animal.data() as Map<String, dynamic>;
            final animalId = animal.id;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Species: ${animalData['species']}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Breed: ${animalData['breed']}'),
                    Text('Birth Date: ${animalData['birthDate']}'),
                    Text('Health Status: ${animalData['healthStatus']}'),
                    Text('Notes: ${animalData['notes'] ?? 'No notes'}'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('animals')
                                .doc(animalId)
                                .delete()
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Animal deleted successfully!')));
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to delete animal: $error')));
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateAnimalPage(
                                  animalId: animalId,
                                  birthDate: animalData['birthDate'],
                                  breed: animalData['breed'],
                                  healthStatus: animalData['healthStatus'],
                                  species: animalData['species'],
                                  notes: animalData['notes'] ?? '',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
