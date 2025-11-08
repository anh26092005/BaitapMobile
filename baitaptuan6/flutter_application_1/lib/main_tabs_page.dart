import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_task_screen.dart';

class MainTabsPage extends StatefulWidget {
  final int initialIndex;
  const MainTabsPage({super.key, this.initialIndex = 0});

  @override
  State<MainTabsPage> createState() => _MainTabsPageState();
}

class _MainTabsPageState extends State<MainTabsPage> {
  late int _index;

  // 🔑 Khai báo duy nhất một GlobalKey để điều khiển ListScreen
  final GlobalKey<ListScreenState> _listKey = GlobalKey<ListScreenState>();

  // Danh sách các tab chính
  late final List<Widget> _tabs = [
    const HomeScreen(),
    ListScreen(key: _listKey),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, _tabs.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_index],

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 👉 Mở màn hình AddTask
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );

          // 👉 Khi nhấn Add xong thì quay về tab List và thêm task mới
          if (result != null && result is Map) {
            setState(() {
              _index = 1; // chuyển qua tab List
            });
            // Ép kiểu Map<dynamic,dynamic> -> Map<String,dynamic>
            _listKey.currentState?.addTaskManually(
              Map<String, dynamic>.from(result),
            );
          }
        },
        child: const Icon(Icons.add),
      ),

      // Giúp nút + nằm giữa thanh bar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(_index == 0 ? Icons.home : Icons.home_outlined),
              onPressed: () => setState(() => _index = 0),
              tooltip: 'Home',
            ),
            IconButton(
              icon: Icon(
                _index == 1 ? Icons.list_alt : Icons.list_alt_outlined,
              ),
              onPressed: () => setState(() => _index = 1),
              tooltip: 'Tasks',
            ),
            const SizedBox(width: 24), // chừa chỗ cho nút +
            IconButton(
              icon: Icon(_index == 2 ? Icons.person : Icons.person_outline),
              onPressed: () => setState(() => _index = 2),
              tooltip: 'Profile',
            ),
            IconButton(
              icon: Icon(
                _index == 3 ? Icons.settings : Icons.settings_outlined,
              ),
              onPressed: () => setState(() => _index = 3),
              tooltip: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
