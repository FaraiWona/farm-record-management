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
