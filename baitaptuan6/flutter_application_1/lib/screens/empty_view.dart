import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  const EmptyView({
    super.key,
    this.title = 'No Tasks Yet!',
    this.subtitle = 'Stay productive - add something to do',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            width: 72,
            child: Stack(
              clipBehavior: Clip.none,
              children: const [
                Positioned.fill(
                  child: Icon(
                    Icons.content_paste,
                    size: 72,
                    color: Colors.black54,
                  ),
                ),
                Positioned(
                  right: -2,
                  top: -6,
                  child: Text(
                    'Z',
                    style: TextStyle(fontSize: 18, color: Colors.black45),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );

    return Align(alignment: Alignment.topCenter, child: card);
  }
}
