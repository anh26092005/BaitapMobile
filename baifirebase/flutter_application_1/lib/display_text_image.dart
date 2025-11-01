import 'package:flutter/material.dart';

class TextPage extends StatelessWidget {
  const TextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Detail"),
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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "The "),
                    TextSpan(
                      text: "quick ",
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.black54,
                      ),
                    ),
                    TextSpan(
                      text: "Brown\n",
                      style: TextStyle(
                        color: Color(0xFFB87333), // màu nâu đồng
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    TextSpan(text: "fox "),
                    TextSpan(
                      text: "j u m p s ",
                      style: TextStyle(letterSpacing: 4),
                    ),
                    TextSpan(
                      text: "over\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(
                      text: "the ",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text: "lazy ",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    TextSpan(text: "dog."),
                  ],
                ),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  height: 1.8, // khoảng cách dòng
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Divider(thickness: 1, color: Colors.black12),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Images"),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // Hình 1
          Image(
            image: NetworkImage(
              "https://xdcs.cdnchinhphu.vn/446259493575335936/2023/8/23/giao-thong-van-tai-9096-16927730679551867829733.jpeg",
            ),
          ),
          SizedBox(height: 8),
          Text(
            "https://giaothongvantaihochiminh.edu.vn/wp-content/uploads/2025/01/Logo-GTVT.png",
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
          SizedBox(height: 24),

          // Hình 2
          Image(
            image: AssetImage("assets/anh.jpg"), // 👈 ảnh trong project
          ),
          SizedBox(height: 8),
          Center(child: Text("In app", style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
