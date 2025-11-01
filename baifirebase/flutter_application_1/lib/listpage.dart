import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UI Components List")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==== DISPLAY ====
          const Text(
            "Display",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text(
                "Text",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Displays text"),
              onTap: () => Navigator.pushNamed(context, '/text'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text(
                "Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Displays an image"),
              onTap: () => Navigator.pushNamed(context, '/image'),
            ),
          ),

          // ==== INPUT ====
          const Text(
            "Input",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text(
                "TextField",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Input field for text"),
              onTap: () => Navigator.pushNamed(context, '/textfield'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text(
                "PasswordField",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Input field for passwords"),
              onTap: () => Navigator.pushNamed(context, '/password'),
            ),
          ),

          // ==== LAYOUT ====
          const Text(
            "Layout",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text(
                "Column",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Arranges elements vertically"),
              onTap: () => Navigator.pushNamed(context, '/column'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text(
                "Row",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Arranges elements horizontally"),
              onTap: () => Navigator.pushNamed(context, '/row'),
            ),
          ),

          //  tu tim hieu
          Container(
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ListTile(
              title: Text(
                "Tự tìm hiểu",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Tìm ra tất cả các thành phần UI cơ bản"),
            ),
          ),
        ],
      ),
    );
  }
}
