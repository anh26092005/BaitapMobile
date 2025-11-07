import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_services.dart';
import 'detail_screen.dart';
import 'empty_view.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = ApiService.fetchTasks();
  }

  Widget _header() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          CircleAvatar(child: Text('UTH')),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'SmartTasks\nA simple and efficient to-do app',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartTasks'),
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
            return Column(
              children: [
                _header(),
                Expanded(
                  child: EmptyView(
                    onRetry: () {
                      setState(() {
                        tasks = ApiService.fetchTasks();
                      });
                    },
                  ),
                ),
              ],
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              children: [
                _header(),
                const Expanded(child: EmptyView()),
              ],
            );
          }
          final items = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _header()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
                  childCount: items.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}
