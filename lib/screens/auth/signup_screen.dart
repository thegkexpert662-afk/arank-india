import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/tenant_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final appIdController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final configured = TenantService.appId;
    if (configured != null && configured.isNotEmpty) appIdController.text = configured;
  }

  Future<String> _generateUniqueUserId() async {
    final random = Random.secure();
    for (int attempt = 0; attempt < 10; attempt++) {
      final number = 100000 + random.nextInt(900000);
      final userId = 'ARK$number';
      final existing = await firestore.collection('users').where('userId', isEqualTo: userId).limit(1).get();
      if (existing.docs.isEmpty) return userId;
    }
    throw Exception('Unable to generate a unique User ID. Please try again.');
  }

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final appId = appIdController.text.trim().toUpperCase();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || appId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password must be at least 6 characters')));
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      setState(() => isLoading = true);

      // Validate and lock the registration to the selected admin tenant BEFORE account creation.
      await TenantService.setAppId(appId);
      final config = await TenantService.getConfig();
      if (!config.exists || config.data()?['isActive'] != true) {
        throw StateError('Invalid or inactive Admin App ID');
      }

      final userId = await _generateUniqueUserId();
      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user == null) throw Exception('Account creation failed.');

      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'userId': userId,
        'name': name,
        'email': email,
        'phone': '',
        'role': 'student',
        'isActive': true,
        'tenantId': appId,
        'appId': appId,
        'tenantAssignedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await user.sendEmailVerification();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Account Created'),
          content: Text('Your ARank India User ID is:\n\n$userId\n\nYour account has been registered with Admin App ID:\n$appId\n\nA verification link has also been sent to your email.'),
          actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('OK'))],
        ),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = e.message ?? 'Signup failed';
      if (e.code == 'email-already-in-use') message = 'This email is already registered.';
      else if (e.code == 'invalid-email') message = 'Please enter a valid email.';
      else if (e.code == 'weak-password') message = 'Password is too weak.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().contains('Invalid or inactive') ? 'Invalid or inactive Admin App ID.' : 'Something went wrong. Please try again.')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    appIdController.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(prefixIcon: Icon(icon), labelText: label, border: const OutlineInputBorder());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent, foregroundColor: Colors.black),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const SizedBox(height: 10),
            Image.asset('assets/images/logos/logo.png', width: 90),
            const SizedBox(height: 30),
            const Text('Create Account', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Register with your Admin App ID', style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 35),
            TextField(controller: nameController, textInputAction: TextInputAction.next, decoration: _dec('Full Name', Icons.person_outline)),
            const SizedBox(height: 18),
            TextField(controller: emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, decoration: _dec('Email', Icons.email_outlined)),
            const SizedBox(height: 18),
            TextField(controller: appIdController, textCapitalization: TextCapitalization.characters, textInputAction: TextInputAction.next, decoration: _dec('Admin App ID', Icons.admin_panel_settings_outlined).copyWith(hintText: 'ARANK-12345678', helperText: 'Enter the App ID given by your Admin.')),
            const SizedBox(height: 18),
            TextField(controller: passwordController, obscureText: hidePassword, textInputAction: TextInputAction.next, decoration: _dec('Password', Icons.lock_outline).copyWith(suffixIcon: IconButton(icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => hidePassword = !hidePassword)))),
            const SizedBox(height: 18),
            TextField(controller: confirmPasswordController, obscureText: hideConfirmPassword, textInputAction: TextInputAction.done, onSubmitted: (_) => isLoading ? null : signUp(), decoration: _dec('Confirm Password', Icons.lock_reset).copyWith(suffixIcon: IconButton(icon: Icon(hideConfirmPassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => hideConfirmPassword = !hideConfirmPassword)))),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: isLoading ? null : signUp, child: isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Create Account', style: TextStyle(fontSize: 18)))),
            const SizedBox(height: 20),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Already have an account? Login')),
          ]),
        ),
      ),
    );
  }
}
