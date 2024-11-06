import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:farm_record_management/screens/authenticate/log_in.dart';
import 'package:farm_record_management/screens/authenticate/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:farm_record_management/screens/crop.dart';
import 'package:farm_record_management/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var logger = Logger();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAWE9PHKzd17dCEZegBmqXIPadA2JGLExc",
        appId: "1:575843924317:android:c116c7b470ce368b7d50b4",
        messagingSenderId: "your-messaging-sender-id",
        projectId: "farm-ca350",
        authDomain: "your-auth-domain",
        storageBucket: "your-storage-bucket",
        measurementId: "your-measurement-id",
      ),
    );

    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);

    logger.i(
        'Firebase initialized successfully with offline persistence enabled');
  } catch (e) {
    logger.e('Error during Firebase initialization: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignInPage(),
        '/crops': (context) => const CropListPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
