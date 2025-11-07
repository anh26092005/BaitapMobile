import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final ValueChanged<bool?>? onCompletedChanged;
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onCompletedChanged,
  });

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('progress')) return Colors.pink.shade100;
    if (s.contains('done') || s.contains('complete')) return Colors.green.shade100;
    return Colors.blue.shade100; // pending/default
  }

  @override
  Widget build(BuildContext context) {
    final color = task.completed ? Colors.green.shade100 : _statusColor(task.status);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: task.completed,
                    onChanged: onCompletedChanged,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(task.description,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                        'Status: ${task.completed ? 'Done' : task.status}'),
                  ),
                  const Spacer(),
                  Text(task.time),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
