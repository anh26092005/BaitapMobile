import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Email',
      theme: ThemeData(useMaterial3: true),
      home: const EmailPage(),
    );
  }
}

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final _emailC = TextEditingController();
  String? _errorText;        // thông báo lỗi (đỏ)
  String? _successMessage;   // thông báo thành công (xanh)

  void _checkEmail() {
    final email = _emailC.text.trim();

    // 1) null/empty → "Email không hợp lệ"
    if (email.isEmpty) {
      return _setError('Email không hợp lệ');
    }

    // 2) không chứa '@' → "Email không đúng định dạng"
    if (!email.contains('@gmail.com')) {
      return _setError('Email không đúng định dạng');
    }

    // 3) Hợp lệ
    setState(() {
      _errorText = null;
      _successMessage = 'Bạn đã nhập email hợp lệ';
    });
  }

  void _setError(String msg) {
    setState(() {
      _errorText = msg;
      _successMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Thực hành 02',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Ô nhập email + nút Kiểm tra
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _emailC,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onChanged: (_) {
                            // gõ lại thì ẩn lỗi/ẩn success
                            if (_errorText != null || _successMessage != null) {
                              setState(() {
                                _errorText = null;
                                _successMessage = null;
                              });
                            }
                          },
                          onSubmitted: (_) => _checkEmail(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _checkEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        ),
                        child: const Text(
                          'Kiểm tra',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Lỗi (đỏ) ngay dưới ô nhập
                  if (_errorText != null)
                    Text(
                      _errorText!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  // Thông báo thành công (xanh)
                  if (_successMessage != null)
                    Text(
                      _successMessage!,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
