import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () {}, child: const Text('Login')),
            TextButton(
              onPressed: () {},
              child: const Text('Continue without account'),
            ),
          ],
        ),
      ),
    );
  }
}
