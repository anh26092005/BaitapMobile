import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tuần 02',
      theme: ThemeData(useMaterial3: true),
      home: const AgeCheckPage(),
    );
  }
}

class AgeCheckPage extends StatefulWidget {
  const AgeCheckPage({super.key});

  @override
  State<AgeCheckPage> createState() => _AgeCheckPageState();
}

class _AgeCheckPageState extends State<AgeCheckPage> {
  final _nameC = TextEditingController();
  final _ageC  = TextEditingController();

  String? _errorText;     // lỗi (đỏ)
  String? _resultText;    // kết quả (xanh)

  void _check() {
    final name = _nameC.text.trim();
    final raw  = _ageC.text.trim();

    // Validate tên
    if (name.isEmpty) {
      return _setError('Họ và tên không được để trống');
    }

    // Validate tuổi (chỉ số)
    if (raw.isEmpty || !RegExp(r'^\d+$').hasMatch(raw)) {
      return _setError('Tuổi không hợp lệ');
    }

    final age = int.parse(raw);
    if (age < 0 || age > 150) {
      return _setError('Tuổi không hợp lệ (0–150)');
    }

    final type = _classify(age);
    setState(() {
      _errorText = null;
      _resultText = 'Họ tên: $name — Tuổi: $age → $type';
    });
  }

  // Phân loại theo đề: Người già (>65), Người lớn (6–65), Trẻ em (2–6), Em bé (<2)
  String _classify(int age) {
    if (age > 65) return 'Người già';
    if (age >= 6) return 'Người lớn';          // 6..65
    if (age >= 2) return 'Trẻ em';              // 2..5
    return 'Em bé';                             // <2
  }

  void _setError(String msg) {
    setState(() {
      _errorText = msg;
      _resultText = null;
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
                    'THỰC HÀNH 01',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Khung xám chứa 2 dòng: nhãn + ô nhập (giống slide)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 90,
                              child: Text('Họ và tên',
                                  style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _nameC,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (_) {
                                  if (_errorText != null || _resultText != null) {
                                    setState(() { _errorText = null; _resultText = null; });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const SizedBox(
                              width: 90,
                              child: Text('Tuổi',
                                  style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _ageC,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onSubmitted: (_) => _check(),
                                onChanged: (_) {
                                  if (_errorText != null || _resultText != null) {
                                    setState(() { _errorText = null; _resultText = null; });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nút Kiểm tra
                  SizedBox(
                    width: 180,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _check,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      child: const Text('Kiểm tra'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (_errorText != null)
                    Text(_errorText!,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600)),

                  if (_resultText != null)
                    Text(_resultText!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
