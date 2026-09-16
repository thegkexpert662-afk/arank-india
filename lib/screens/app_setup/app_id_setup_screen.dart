import 'package:flutter/material.dart';

import '../../services/tenant_service.dart';
import '../auth/login_screen.dart';

class AppIdSetupScreen extends StatefulWidget {
  const AppIdSetupScreen({super.key});

  @override
  State<AppIdSetupScreen> createState() => _AppIdSetupScreenState();
}

class _AppIdSetupScreenState extends State<AppIdSetupScreen> {
  final _controller = TextEditingController();
  bool _saving = false;

  Future<void> _continue() async {
    final id = _controller.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your App ID')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await TenantService.setAppId(id);
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid App ID: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student App Setup'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logos/logo.png',
                      width: 90,
                      height: 90,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Connect your Student App',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter the unique App ID provided by your Admin. You only need to do this once on this device.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'App ID',
                        hintText: 'ARANK-12345678',
                        prefixIcon: Icon(Icons.key_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _continue,
                        child: Text(
                          _saving ? 'Connecting...' : 'Connect App',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
