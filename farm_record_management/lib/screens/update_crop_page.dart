import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCropPage extends StatelessWidget {
  final String cropId;
  final String cropName;
  final String plantingDate;
  final String harvestDate;
  final String quantity;
  final String notes;
