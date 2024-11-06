import 'package:farm_record_management/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var logger = Logger();

  Future<void> _signUpWithEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      setState(() {
        _isLoading = true;
      });

      try {
        User? user = await _auth.signUpWithEmailAndPassword(email, password);
        if (user != null) {
          if (mounted) {
            logger.i('Sign up successful');
            Navigator.pushReplacementNamed(
                context, '/crops'); 
          }
        } else {
          if (mounted) {
            logger.w('Error during sign-up');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sign-up failed')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          logger.e('Error during sign-up: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during sign-up: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }