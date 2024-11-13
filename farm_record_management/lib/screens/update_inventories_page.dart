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

