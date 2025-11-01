import 'package:flutter/material.dart';

class TextFieldPage extends StatefulWidget {
  const TextFieldPage({super.key});

  @override
  State<TextFieldPage> createState() => TextFieldPageState();
}

class TextFieldPageState extends State<TextFieldPage> {
  final _controller = TextEditingController();
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TextField"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.lightBlue),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.lightBlue,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        iconTheme: const IconThemeData(color: Colors.lightBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Thông tin nhập",
              ),
              onChanged: (value) => setState(() => _text = value),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 32),
            Text(
              _text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordFieldPage extends StatefulWidget {
  const PasswordFieldPage({super.key});

  @override
  State<PasswordFieldPage> createState() => _PasswordFieldPageState();
}

class _PasswordFieldPageState extends State<PasswordFieldPage> {
  bool _isHidden = true; // 👁️ trạng thái ẩn/hiện mật khẩu
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PassField"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.lightBlue),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.lightBlue,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        iconTheme: const IconThemeData(color: Colors.lightBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Nhập mật khẩu:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              obscureText: _isHidden, // 👈 ẩn/hiện text
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Nhập mật khẩu",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isHidden ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isHidden = !_isHidden; // đổi trạng thái ẩn/hiện
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
