import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'update_crop_page.dart';
import 'home_page.dart';
import 'animal_home_page.dart';
import 'update_animals_page.dart';

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
            ListTile(
              title: const Text('Manage Crops'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              title: const Text('Manage Animals'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnimalHomePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0), 
          child: Column(
            children: [
              _buildCropsSection(),
              const SizedBox(height: 20), 
              _buildAnimalsSection(),
            ],
          ),
        ),
      ),
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

         return ExpansionTile(
          title: const Text('Crops', style: TextStyle(fontSize: 20)),
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

        return ExpansionTile(
          title: const Text('Animals', style: TextStyle(fontSize: 20)),
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
