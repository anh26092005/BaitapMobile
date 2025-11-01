import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const LibraryApp());

/// ====== MODELS ======
class Book {
  final String id;
  final String title;
  final String author;

  Book({required this.id, required this.title, required this.author});
}

class Student {
  final String id;
  String name;

  Student({required this.id, required this.name});
}

/// ====== STORE (in-memory) ======
class LibraryStore extends ChangeNotifier {
  final List<Book> books = [
    Book(id: 'b1', title: 'Clean Code', author: 'Robert C. Martin'),
    Book(id: 'b2', title: 'Flutter in Action', author: 'Eric Windmill'),
    Book(id: 'b3', title: 'Design Patterns', author: 'GoF'),
    Book(id: 'b4', title: 'Operating Systems', author: 'Silberschatz'),
    Book(id: 'b5', title: 'Computer Networks', author: 'Tanenbaum'),
  ];

  final List<Student> students = [
    Student(id: 's1', name: 'Nguyen Van A'),
    Student(id: 's2', name: 'Nguyen Van B'),
    Student(id: 's3', name: 'Nguyen Van C'),
  ];

  /// Map<studentId, Set<bookId>>
  final Map<String, Set<String>> _borrows = {};

  String? currentStudentId = 's3'; // mặc định chọn Nguyen Van C

  Student? get currentStudent =>
      students.where((s) => s.id == currentStudentId).firstOrNull;

  List<Book> get currentBorrowedBooks {
    final ids = _borrows[currentStudentId] ?? {};
    return books.where((b) => ids.contains(b.id)).toList();
  }

  bool isBorrowedByAnyone(String bookId) {
    for (final set in _borrows.values) {
      if (set.contains(bookId)) return true;
    }
    return false;
  }

  void setCurrentStudentByName(String name) {
    final found = students.firstWhere(
      (s) => s.name.toLowerCase().trim() == name.toLowerCase().trim(),
      orElse: () => Student(id: 's${Random().nextInt(999999)}', name: name),
    );

    // Nếu là sinh viên mới (chưa có trong danh sách) thì thêm vào
    if (!students.any((s) => s.id == found.id)) {
      students.add(found);
    }

    currentStudentId = found.id;
    notifyListeners();
  }

  void addBorrowForCurrent(Set<String> bookIds) {
    if (currentStudentId == null) return;
    final set = _borrows.putIfAbsent(currentStudentId!, () => <String>{});
    set.addAll(bookIds);
    notifyListeners();
  }

  void removeBorrowForCurrent(String bookId) {
    if (currentStudentId == null) return;
    _borrows[currentStudentId!]?.remove(bookId);
    notifyListeners();
  }

  void addStudent(String name) {
    students.add(Student(id: 's${Random().nextInt(999999)}', name: name));
    notifyListeners();
  }

  void removeStudent(String id) {
    students.removeWhere((s) => s.id == id);
    _borrows.remove(id);
    if (currentStudentId == id) currentStudentId = students.firstOrNull?.id;
    notifyListeners();
  }

  void addBook(String title, String author) {
    books.add(
      Book(id: 'b${Random().nextInt(999999)}', title: title, author: author),
    );
    notifyListeners();
  }

  void removeBook(String id) {
    books.removeWhere((b) => b.id == id);
    for (final set in _borrows.values) {
      set.remove(id);
    }
    notifyListeners();
  }
}

extension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

/// ====== APP & HOME ======
class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hệ thống Quản lý Thư viện',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false, primarySwatch: Colors.blue),
      home: StoreProvider(child: const HomeScreen()),
    );
  }
}

/// Một InheritedWidget đơn giản để truyền LibraryStore xuống cây widget
class StoreProvider extends StatefulWidget {
  final Widget child;
  const StoreProvider({super.key, required this.child});

  static _StoreScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_StoreScope>();
    assert(scope != null, 'StoreScope not found');
    return scope!;
  }

  @override
  State<StoreProvider> createState() => _StoreProviderState();
}

class _StoreProviderState extends State<StoreProvider> {
  final LibraryStore store = LibraryStore();

  @override
  Widget build(BuildContext context) {
    return _StoreScope(store: store, child: widget.child);
  }
}

class _StoreScope extends InheritedWidget {
  final LibraryStore store;
  const _StoreScope({required this.store, required super.child});

  @override
  bool updateShouldNotify(_StoreScope oldWidget) => store != oldWidget.store;
}

/// ====== SCREENS ======
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of(context).store;

    final pages = [
      ManageTab(store: store),
      BooksTab(store: store),
      StudentsTab(store: store),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Quản lý',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'DS Sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Sinh viên',
          ),
        ],
      ),
    );
  }
}

/// Tab 1: Quản lý mượn sách (như ảnh)
class ManageTab extends StatefulWidget {
  final LibraryStore store;
  const ManageTab({super.key, required this.store});

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab> {
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(
      text: widget.store.currentStudent?.name ?? '',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nameCtrl.text = widget.store.currentStudent?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final student = store.currentStudent;

    return SafeArea(
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final borrowed = store.currentBorrowedBooks;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Hệ thống\nQuản lý Thư viện',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),

                /// --- Nhập tên sinh viên + Thay đổi ---
                const Text(
                  'Sinh viên',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên sinh viên',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final name = _nameCtrl.text.trim();
                        if (name.isEmpty) return;
                        store.setCurrentStudentByName(name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Đang làm việc với: ${store.currentStudent?.name}',
                            ),
                          ),
                        );
                        setState(() {}); // cập nhật field hiển thị
                      },
                      child: const Text('Thay đổi'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// --- Danh sách sách đã mượn ---
                const Text(
                  'Danh sách sách',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 180,
                  child: borrowed.isEmpty
                      ? Center(
                          child: Text(
                            'Bạn chưa mượn quyển sách nào\nNhấn "Thêm" để bắt đầu hành trình đọc sách!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (_, i) {
                            final b = borrowed[i];
                            return Dismissible(
                              key: ValueKey('borrow_${b.id}'),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 16),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) =>
                                  store.removeBorrowForCurrent(b.id),
                              child: ListTile(
                                dense: true,
                                title: Text(b.title),
                                subtitle: Text('Tác giả: ${b.author}'),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemCount: borrowed.length,
                        ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: SizedBox(
                    width: 180,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: student == null
                          ? null
                          : () async {
                              final selected =
                                  await showModalBottomSheet<Set<String>>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (_) =>
                                        ChooseBooksSheet(store: store),
                                  );
                              if (selected != null && selected.isNotEmpty) {
                                store.addBorrowForCurrent(selected);
                              }
                            },
                      child: const Text('Thêm'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// BottomSheet: tick chọn sách bằng Checkbox
class ChooseBooksSheet extends StatefulWidget {
  final LibraryStore store;
  const ChooseBooksSheet({super.key, required this.store});

  @override
  State<ChooseBooksSheet> createState() => _ChooseBooksSheetState();
}

class _ChooseBooksSheetState extends State<ChooseBooksSheet> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final borrowedIds = store.currentBorrowedBooks
        .map((b) => b.id)
        .toSet(); // đã mượn bởi sinh viên hiện tại

    return SafeArea(
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 8,
              left: 12,
              right: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 6),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Chọn sách để mượn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: store.books.length,
                    itemBuilder: (_, i) {
                      final b = store.books[i];
                      final isBorrowedBySomeone = store.isBorrowedByAnyone(
                        b.id,
                      );
                      final isDisabled =
                          isBorrowedBySomeone && !borrowedIds.contains(b.id);
                      return CheckboxListTile(
                        title: Text(b.title),
                        subtitle: Text(
                          'Tác giả: ${b.author}${isDisabled ? "  • ĐÃ MƯỢN" : ""}',
                        ),
                        value:
                            _selected.contains(b.id) ||
                            borrowedIds.contains(b.id),
                        onChanged: isDisabled
                            ? null
                            : (v) {
                                setState(() {
                                  if (v == true) {
                                    _selected.add(b.id);
                                  } else {
                                    _selected.remove(b.id);
                                  }
                                });
                              },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, _selected),
                        child: const Text('Xác nhận'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Tab 2: Danh sách Sách (quản lý kho)
class BooksTab extends StatelessWidget {
  final LibraryStore store;
  const BooksTab({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final titleCtrl = TextEditingController();
    final authorCtrl = TextEditingController();

    return SafeArea(
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return Scaffold(
            body: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: store.books.length,
              itemBuilder: (_, i) {
                final b = store.books[i];
                final borrowed = store.isBorrowedByAnyone(b.id);
                return ListTile(
                  title: Text(b.title),
                  subtitle: Text('Tác giả: ${b.author}'),
                  trailing: borrowed
                      ? const Chip(label: Text('Đang mượn'))
                      : IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => store.removeBook(b.id),
                        ),
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 1),
            ),
            floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('Thêm sách'),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Thêm sách'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Tiêu đề',
                          ),
                        ),
                        TextField(
                          controller: authorCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Tác giả',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (titleCtrl.text.trim().isNotEmpty &&
                              authorCtrl.text.trim().isNotEmpty) {
                            store.addBook(
                              titleCtrl.text.trim(),
                              authorCtrl.text.trim(),
                            );
                            titleCtrl.clear();
                            authorCtrl.clear();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Lưu'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Tab 3: Danh sách Sinh viên
class StudentsTab extends StatelessWidget {
  final LibraryStore store;
  const StudentsTab({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();

    return SafeArea(
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return Scaffold(
            body: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: store.students.length,
              itemBuilder: (_, i) {
                final s = store.students[i];
                final isCurrent = store.currentStudentId == s.id;
                return ListTile(
                  title: Text(s.name),
                  leading: isCurrent
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : const Icon(Icons.person),
                  onTap: () {
                    store.currentStudentId = s.id;
                    store.notifyListeners();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đang làm việc với: ${s.name}')),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => store.removeStudent(s.id),
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 1),
            ),
            floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Thêm SV'),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Thêm sinh viên'),
                    content: TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Họ tên'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (nameCtrl.text.trim().isNotEmpty) {
                            store.addStudent(nameCtrl.text.trim());
                            nameCtrl.clear();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Lưu'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
