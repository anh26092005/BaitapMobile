import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'onboarding_welcome.dart';

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({super.key});

  @override
  State<FacebookLoginPage> createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  Future<void> loginWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success) {
        throw Exception('Đăng nhập Facebook thất bại: ${loginResult.message}');
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Welcome(
            displayName: userCredential.user?.displayName ?? "Không rõ tên",
            photoURL: userCredential.user?.photoURL ?? "",
            email: userCredential.user?.email ?? "",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Lỗi đăng nhập Facebook: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Facebook Login')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: loginWithFacebook,
          icon: const Icon(Icons.facebook, size: 32),
          label: const Text('Đăng nhập bằng Facebook'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size(250, 50),
          ),
        ),
      ),
    );
  }
}
