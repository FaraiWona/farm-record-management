import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateFinancialsPage extends StatefulWidget {
  final String financialId;
  final String transactionType;
  final String amount;
  final String date;
  final String description;
  final String notes;

  const UpdateFinancialsPage({
    super.key,
    required this.financialId,
    required this.transactionType,
    required this.amount,
    required this.date,
    required this.description,
    required this.notes,
  });
