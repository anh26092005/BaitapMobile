import 'package:flutter/material.dart';

class RowLayoutPage extends StatelessWidget {
  const RowLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Row Layout",
          style: TextStyle(color: Colors.lightBlue),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBox(false),
                  const SizedBox(width: 16),
                  _buildBox(true),
                  const SizedBox(width: 16),
                  _buildBox(false),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBox(bool isDark) {
    return Container(
      width: 70,
      height: 50,
      decoration: BoxDecoration(
        color: isDark ? Colors.blue[500] : Colors.blue[200],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class ColumnLayoutPage extends StatelessWidget {
  const ColumnLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Column Layout",
          style: TextStyle(color: Colors.lightBlue),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBox(false), // ô trên (nhạt)
                  const SizedBox(height: 16),
                  _buildBox(true), // ô giữa (đậm)
                  const SizedBox(height: 16),
                  _buildBox(false), // ô dưới (nhạt)
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // Hàm tạo box
  Widget _buildBox(bool isDark) {
    return Container(
      width: 70,
      height: 50,
      decoration: BoxDecoration(
        color: isDark ? Colors.blue[500] : Colors.blue[200],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
