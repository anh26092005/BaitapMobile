import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  final String displayName;
  final String photoURL;
  final String email;

  const Welcome({
    super.key,
    required this.displayName,
    required this.photoURL,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(backgroundImage: NetworkImage(photoURL), radius: 50),
            const SizedBox(height: 20),
            Text(
              '👋 Xin chào, $displayName',
              style: const TextStyle(fontSize: 20),
            ),
            Text('📧 $email', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('⬅ Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
