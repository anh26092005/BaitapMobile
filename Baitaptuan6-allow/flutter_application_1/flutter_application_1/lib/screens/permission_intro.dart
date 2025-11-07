import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login_screen.dart';

class PermissionIntro extends StatefulWidget {
  const PermissionIntro({super.key});

  @override
  State<PermissionIntro> createState() => _PermissionIntroState();
}

class _PermissionIntroState extends State<PermissionIntro> {
  final PageController _controller = PageController();
  int _index = 0;
  bool _isRequesting = false; // ✅ chặn bấm liên tục

  final List<_PermissionData> _permissions = [
    _PermissionData(
      icon: Icons.location_on,
      title: 'Location',
      description: 'Allow maps to access your location while you use the app?',
      buttonText: 'Allow',
      type: Permission.location,
    ),
    _PermissionData(
      icon: Icons.notifications_active,
      title: 'Notification',
      description:
          'Please enable notifications to receive updates and reminders.',
      buttonText: 'Turn on',
      type: Permission.notification,
    ),
    _PermissionData(
      icon: Icons.camera_alt,
      title: 'Camera',
      description: 'We need access to your camera to scan QR codes.',
      buttonText: 'Turn on',
      type: Permission.camera,
    ),
  ];

  Future<void> _requestPermission(Permission permission) async {
    if (_isRequesting) return; // ✅ tránh gọi trùng
    _isRequesting = true;

    try {
      final status = await permission.request();

      if (!mounted) return;
      if (status.isGranted) {
        _nextPage();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Permission denied')));
      }
    } catch (e) {
      debugPrint('Permission error: $e');
    } finally {
      _isRequesting = false; // ✅ mở khóa
    }
  }

  void _nextPage() {
    if (_index < _permissions.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          onPageChanged: (i) => setState(() => _index = i),
          itemCount: _permissions.length,
          itemBuilder: (context, i) {
            final item = _permissions[i];
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, size: 80, color: Colors.orange),
                    const SizedBox(height: 20),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isRequesting
                          ? null
                          : () => _requestPermission(item.type),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isRequesting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              item.buttonText,
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _isRequesting ? null : _nextPage,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Skip for now',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PermissionData {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final Permission type;

  _PermissionData({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.type,
  });
}
