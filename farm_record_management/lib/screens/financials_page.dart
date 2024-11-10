import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crop.dart';
class FinancialsPage extends StatelessWidget {
  const FinancialsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farm Financials',
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