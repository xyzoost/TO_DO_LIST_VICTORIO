import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'helperss/helper_token.dart';

class CreateTodoPage extends StatefulWidget {
  const CreateTodoPage({super.key});

  @override
  State<CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  final listController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  int? userId;
  String status = 'low';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  Future<void> createTodo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User belum login')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/todos'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'list': listController.text,
        'tanggal': dateController.text,
        'deskripsi': descriptionController.text,
        'status': status,
        'id_users': userId,
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // putih

      appBar: AppBar(
        backgroundColor: Colors.red, // merah
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Todo',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Form Todo',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // Nama List
              TextField(
                controller: listController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Nama List',
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.list_alt, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 16),

              // Tanggal
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        pickedDate.toIso8601String().split('T')[0];
                    setState(() {
                      dateController.text = formattedDate;
                    });
                  }
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon:
                      const Icon(Icons.calendar_today, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 16),

              // Deskripsi
              TextField(
                controller: descriptionController,
                maxLines: 3,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon:
                      const Icon(Icons.description, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Prioritas',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Georgia',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: status,
                  isExpanded: true,
                  underline: Container(),
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (val) => setState(() => status = val!),
                  items: ['low', 'medium', 'high'].map((e) {
                    IconData icon = e == 'low'
                        ? Icons.arrow_downward
                        : e == 'medium'
                            ? Icons.horizontal_rule
                            : Icons.arrow_upward;
                    Color color = e == 'low'
                        ? Colors.green
                        : e == 'medium'
                            ? Colors.orange
                            : Colors.red;
                    return DropdownMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          Icon(icon, color: color),
                          const SizedBox(width: 10),
                          Text(e.toUpperCase()),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: createTodo,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Perubahan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Merah
                    foregroundColor: Colors.white, // Teks putih
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
