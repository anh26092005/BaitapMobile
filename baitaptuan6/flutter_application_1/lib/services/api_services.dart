import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  /// SỬA base này cho đúng workspace Amock của bạn
  static const String _base = 'https://amock.io/api/ngocanhprox';

  static const _timeout = Duration(seconds: 10);
  static const _headers = {'Content-Type': 'application/json'};

  /// GET /tasks  -> danh sách rút gọn
  static Future<List<Task>> fetchTasks() async {
    try {
      final uri = Uri.parse('$_base/tasks');
      final res = await http.get(uri, headers: _headers).timeout(_timeout);

      if (res.statusCode != 200) return <Task>[];

      final body = json.decode(res.body);
      if (body is! List) return <Task>[];

      return body.whereType<Map<String, dynamic>>().map(Task.fromJson).toList();
    } on TimeoutException {
      return <Task>[];
    } catch (_) {
      return <Task>[];
    }
  }

  /// GET /task/:id -> chi tiết (có subtasks)
  static Future<Task> fetchTaskDetail(int id) async {
    try {
      final uri = Uri.parse('$_base/task/$id');
      final res = await http.get(uri, headers: _headers).timeout(_timeout);
      if (res.statusCode != 200) {
        throw Exception('GET /task/$id -> ${res.statusCode}');
      }

      final decoded = json.decode(res.body);
      Map<String, dynamic>? map;

      if (decoded is Map<String, dynamic>) {
        // Accept { ... } or { data: {...} } or { task: {...} }
        if (decoded.containsKey('data') && decoded['data'] is Map<String, dynamic>) {
          map = decoded['data'] as Map<String, dynamic>;
        } else if (decoded.containsKey('task') && decoded['task'] is Map<String, dynamic>) {
          map = decoded['task'] as Map<String, dynamic>;
        } else {
          map = decoded;
        }
      } else if (decoded is List) {
        // Some mocks return an array with a single item
        final first = decoded.cast<dynamic>().firstWhere(
          (e) => e is Map<String, dynamic>,
          orElse: () => null,
        );
        if (first is Map<String, dynamic>) map = first;
      }

      if (map == null) {
        throw FormatException('Invalid detail JSON format');
      }
      return Task.fromJson(map);
    } on TimeoutException {
      rethrow;
    } catch (e) {
      // Print for easier debugging in console
      // ignore: avoid_print
      print('fetchTaskDetail($id) error: $e');
      rethrow;
    }
  }

  /// DELETE /task/:id -> xoá task
  /// Trả true nếu xoá thành công (200/204 hoặc body có {"success":true})
  static Future<bool> deleteTask(int id) async {
    final uri = Uri.parse('$_base/task/$id');
    final res = await http.delete(uri, headers: _headers).timeout(_timeout);

    if (res.statusCode == 200 || res.statusCode == 204) return true;

    // Một số mock trả 200/201 với body success
    try {
      final body = json.decode(res.body);
      if (body is Map && body['success'] == true) return true;
    } catch (_) {}

    return false;
  }
}
