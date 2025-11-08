import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_services.dart';
import '../widgets/task_card.dart';
import 'detail_screen.dart';
import 'empty_view.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

// 👉 Bước 1: Thêm typedef để MainTabsPage có thể truy cập state này qua GlobalKey
typedef ListScreenState = _ListScreenState;

class _ListScreenState extends State<ListScreen> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = ApiService.fetchTasks();
  }

  // 👉 Bước 2: Thêm hàm này để nhận task mới từ AddTaskScreen
  void addTaskManually(Map<String, dynamic> data) {
    setState(() {
      tasks = tasks.then((existing) {
        // clone danh sách cũ
        final updated = List<Task>.from(existing);
        // thêm task mới lên đầu danh sách
        updated.insert(
          0,
          Task(
            id: DateTime.now().millisecondsSinceEpoch, // tạm id random
            title: data['title'] ?? 'Untitled Task',
            description: data['description'] ?? '',
            completed: false,
            status: 'New',
            time: DateTime.now().toIso8601String(),
            subtasks: const [],
          ),
        );
        return updated;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: () {
              setState(() {
                tasks = ApiService.fetchTasks();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return EmptyView(
              onRetry: () {
                setState(() {
                  tasks = ApiService.fetchTasks();
                });
              },
            );
          }

          final items = snapshot.data ?? const <Task>[];
          if (items.isEmpty) {
            return const EmptyView();
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final task = items[index];
              return TaskCard(
                task: task,
                onTap: () async {
                  final deleted = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(taskId: task.id),
                    ),
                  );
                  if (deleted == true) {
                    setState(() {
                      tasks = ApiService.fetchTasks();
                    });
                  }
                },
                onCompletedChanged: (v) {
                  setState(() {
                    items[index] = task.copyWith(completed: v ?? false);
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
