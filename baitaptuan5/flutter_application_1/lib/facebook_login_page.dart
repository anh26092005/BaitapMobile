import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({super.key});

  @override
  State<FacebookLoginPage> createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  User? _user; // user hiện tại
  bool _loading = false;

  // Hàm đăng nhập bằng Facebook
  Future<void> _loginWithFacebook() async {
    setState(() => _loading = true);

    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Lấy access token từ Facebook
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        // Đăng nhập vào Firebase
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);

        setState(() {
          _user = userCredential.user;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Đăng nhập Facebook thành công!")),
        );
      } else if (result.status == LoginStatus.cancelled) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("❌ Bạn đã huỷ đăng nhập")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("⚠️ Lỗi: ${result.message}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("🔥 Lỗi đăng nhập: $e")));
    }

    setState(() => _loading = false);
  }

  // Hàm đăng xuất
  Future<void> _logout() async {
    await FacebookAuth.instance.logOut();
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập bằng Facebook'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _user == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Chưa đăng nhập", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _loginWithFacebook,
                    icon: const Icon(Icons.facebook, color: Colors.white),
                    label: const Text(
                      "Đăng nhập bằng Facebook",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_user!.photoURL ?? ""),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _user!.displayName ?? "Không rõ tên",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(_user!.email ?? ""),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text("Đăng xuất"),
                  ),
                ],
              ),
      ),
    );
  }
}
