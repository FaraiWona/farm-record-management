import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateAnimalPage extends StatelessWidget {
   final String animalId;
  final String birthDate;
  final String breed;
  final String healthStatus;
  final String species;
  final String notes;

const UpdateAnimalPage({
    super.key,
    required this.animalId,
    required this.birthDate,
    required this.breed,
    required this.healthStatus,
    required this.species,
    required this.notes,
  });
