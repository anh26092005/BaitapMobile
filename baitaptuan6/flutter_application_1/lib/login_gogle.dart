import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_tabs_page.dart';

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _loading = false;

  Future<void> loginWithGoogle() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      // Ensure account chooser shows up if already signed in
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Canceled Google sign-in')),
          );
        }
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // After login open Home (tab index 0)
          builder: (_) => const MainTabsPage(initialIndex: 0),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _logoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 240,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'UTH',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color(0xFF00796B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'SmartTasks',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            const Text('A simple and efficient to-do app'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login-Flow'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _logoCard(),
                  const SizedBox(height: 24),
                  const Text('Welcome', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  const Text('Ready to explore? Log in to get started.'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : loginWithGoogle,
                      icon: const Icon(Icons.g_translate, color: Colors.black),
                      label: const Text('SIGN IN WITH GOOGLE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE3F2FD),
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(48),
                        side: const BorderSide(color: Color(0xFF90CAF9)),
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  if (_loading) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                  const SizedBox(height: 24),
                  Text('(c) UTHSmartTasks',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

