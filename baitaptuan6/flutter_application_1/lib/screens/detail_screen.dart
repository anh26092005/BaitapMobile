import 'package:flutter/material.dart';
import '../models/task.dart' as models;
import '../services/api_services.dart';
import 'empty_view.dart';

class DetailScreen extends StatefulWidget {
  final int taskId;
  const DetailScreen({super.key, required this.taskId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<models.Task> task;
  models.Task? _current; // giữ bản sao để cập nhật trạng thái checkbox cục bộ

  @override
  void initState() {
    super.initState();
    task = ApiService.fetchTaskDetail(widget.taskId);
  }

  Future<void> _deleteTask() async {
    final ok = await ApiService.deleteTask(widget.taskId);
    if (mounted) {
      if (ok) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Đã xóa Task')));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Xóa thất bại')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Xóa',
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Xóa công việc?'),
                  content: const Text('Thao tác này không thể hoàn tác.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Xóa'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await _deleteTask();
              }
            },
          )
        ],
      ),
      body: FutureBuilder<models.Task>(
        future: task,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Hiển thị gợi ý khi JSON/endpoint sai
            return const EmptyView(
              title: 'No Tasks Yet!',
              subtitle: 'Không đọc được dữ liệu chi tiết. Kiểm tra JSON /task/:id',
            );
          }
          if (!snapshot.hasData) {
            return const EmptyView();
          }
          _current ??= snapshot.data!;
          final t = _current!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Status: ${t.status}'),
                Text('Time: ${t.time}'),
                const SizedBox(height: 20),
                Text(t.description),
                const SizedBox(height: 16),
                if (t.subtasks.isNotEmpty) ...[
                  const Text(
                    'Subtasks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    itemCount: t.subtasks.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final st = t.subtasks[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CheckboxListTile(
                          value: st.done,
                          onChanged: (v) {
                            setState(() {
                              t.subtasks[index] =
                                  st.copyWith(done: v ?? st.done);
                            });
                          },
                          title: Text(st.title),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    },
                  ),
                ],
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Xóa công việc?'),
                        content:
                            const Text('Thao tác này không thể hoàn tác.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Xóa'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await _deleteTask();
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Xóa Task'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
