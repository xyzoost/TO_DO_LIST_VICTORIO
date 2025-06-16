import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'create.dart';
import 'edit.dart';
import 'signin_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List todos = [];
  bool isLoading = false;

  Future<void> fetchTodos() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      print('Token tidak ditemukan, user belum login.');
      if (!mounted) return;
      setState(() => isLoading = false);
      return;
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/todos'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (!mounted) return;
      setState(() => todos = jsonDecode(response.body));
    } else {
      print('Gagal fetch todos: ${response.statusCode} - ${response.body}');
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> deleteTodo(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      print('Token tidak ditemukan, user belum login.');
      return;
    }

    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/todos/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('DELETE status: ${response.statusCode}');
    print('DELETE response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (!mounted) return;
      fetchTodos();
    } else {
      print('Gagal menghapus: ${response.statusCode}');
    }
  }

  Future<void> toggleIsDone(int id, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      print('Token tidak ditemukan, user belum login.');
      return;
    }

    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/edit/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'selesai': value}),
    );
    print('Update response status: ${response.statusCode}');
    print('Update response body: ${response.body}');
    if (response.statusCode == 200) {
      if (!mounted) return;
      fetchTodos(); // Refresh data
    } else {
      print('Gagal update is_done: ${response.body}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.black, // Black app bar
        elevation: 0,
        title: Row(
          children: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              onSelected: (value) {
                if (value == 'logout') logout();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Text(
              'FluTodo',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: todos.length,
              itemBuilder: (context, i) {
                final item = todos[i];
                final isDone = item['selesai'] == 1 || item['selesai'] == true;

                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 400 + (i * 100)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      width: 500,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white, // White background
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.red, width: 1), // Red border
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        leading: Checkbox(
                          value: isDone,
                          onChanged: (val) {
                            if (val != null) toggleIsDone(item['id_todo'], val);
                          },
                          activeColor: Colors.red, // Red checkbox
                          checkColor: Colors.white,
                        ),
                        title: Text(
                          item['list'] ?? '',
                          style: TextStyle(
                            color: Colors.black, // Black text
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.bold,
                            decoration:
                                isDone ? TextDecoration.lineThrough : null,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['tanggal'],
                                style: const TextStyle(
                                  color: Colors.black54, // Dark gray
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                'Prioritas: ${item['status'] ?? ''}',
                                style: TextStyle(
                                  color: item['status'] == 'high'
                                      ? Colors.red[800]
                                      : item['status'] == 'medium'
                                          ? Colors.red[600]
                                          : Colors.red[400],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isDone)
                                const Text(
                                  '✔ Selesai',
                                  style: TextStyle(
                                    color: Colors.red, // Red for completed
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        trailing: Wrap(
                          spacing: 2,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.description,
                                  color: Colors.black),
                              tooltip: 'Deskripsi',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text(
                                      'Deskripsi',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                      item['deskripsi'] ??
                                          'Tidak ada deskripsi',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          'Tutup',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black),
                              tooltip: 'Edit',
                              onPressed: () async {
                                final updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTodoPage(
                                      todo: item,
                                      id: item['id_todo'],
                                    ),
                                  ),
                                );
                                if (updated == true) fetchTodos();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Hapus',
                              onPressed: () => deleteTodo(item['id_todo']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red, // Red FAB
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTodoPage()),
          );
          if (created == true) fetchTodos();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
