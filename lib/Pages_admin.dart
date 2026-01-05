import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Admin_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _emailController = TextEditingController();
  String? _error;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _error = 'Введите почту';
        return;
      });
    }
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/admin/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['role'] == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
          );
        } else {
          setState(() {
            _error = 'Вы не администратор';
          });
        }
      } else {
        setState(() {
          _error = 'Ошибка входа';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка сети';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 217, 201),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Вход для администратора', style: TextStyle(fontSize: 25)),
              Padding(padding: EdgeInsets.all(20)),
              SizedBox(
                width: 500,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF3A2B28),
                        width: 3.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF3A2B28),
                        width: 3.0,
                      ),
                    ),
                    hintText: 'email',
                  ),
                ),
              ),

              SizedBox(height: 30),
              ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 23),
                        backgroundColor: Color(0xFF3A2B28),
                        elevation: 5,
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          left: 40,
                          right: 40,
                        ),
                      ),
                      child: Text(
                        'ДАЛЕЕ',
                        style: TextStyle(color: Color.fromARGB(255, 255, 252, 231),),
                      ),
                    ),
              if (_error != null) ...[
                SizedBox(height: 10),
                Text(_error!, style: TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
