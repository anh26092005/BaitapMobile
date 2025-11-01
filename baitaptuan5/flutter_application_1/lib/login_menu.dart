import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_gogle.dart';
import 'package:flutter_application_1/login_facebook.dart';
import 'package:flutter_application_1/login_email.dart';
import 'package:flutter_application_1/login_phone.dart';

class LoginMenuPage extends StatelessWidget {
  const LoginMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn phương thức đăng nhập'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.email),
                label: const Text("Đăng nhập bằng Email"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(250, 50),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmailLoginPage()),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.facebook),
                label: const Text("Đăng nhập bằng Facebook"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(250, 50),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FacebookLoginPage()),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text("Đăng nhập bằng Số điện thoại"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(250, 50),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PhoneLoginPage()),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Đăng nhập bằng Google"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(250, 50),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GoogleLoginPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
