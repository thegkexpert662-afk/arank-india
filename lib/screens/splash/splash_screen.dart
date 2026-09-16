import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';
import '../home/home_screen.dart';
import '../../services/tenant_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    Widget next;

    if (user != null) {
      // Restore the student's tenant association before opening the app.
      await TenantService.attachStudentToTenant(user.uid);
      next = const HomeScreen();
    } else {
      // Login is the default entry point.
      // New students can use the Sign Up option there, where Admin App ID
      // is entered along with the registration details.
      next = const LoginScreen();
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F9FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logos/logo.png',
                  width: 120,
                  height: 120,
                )
                    .animate()
                    .scale(duration: 700.ms, curve: Curves.easeOutBack)
                    .fadeIn(),
                const SizedBox(height: 28),
                const Text(
                  'ARank India',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 55,
                      height: 2,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'I N D I A',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2962FF),
                        letterSpacing: 8,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 55,
                      height: 2,
                      color: Colors.orange,
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 900.ms, delay: 500.ms),
                const SizedBox(height: 12),
                Text(
                  'Learn • Practice • Rank',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    letterSpacing: 1,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 900.ms)
                    .slideY(begin: 0.4, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
