import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Pages_1.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/bookings'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          bookings = data.map((item) => item as Map<String, dynamic>).toList();
        });
      }
    } catch (e) {
      print('Ошибка загрузки броней: $e');
    }
  }

  Future<void> _updateBookings(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/bookings/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        _loadBookings();
      }
    } catch (e) {
      print('Ошибка обновления брони: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Админ-панель'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PagesScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Имя: ${booking['name']}'),
                  Text('Телефон: ${booking['phone']}'),
                  Text('Дата: ${booking['date']}'),
                  Text('Время: ${booking['time']}'),
                  Text('Стол: ${booking['tableId']}'),
                  Text('Гости: ${booking['guests']}'),
                  Text('Статус: ${booking['status']}'),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _updateBookings(booking['id'], 'confirmed'),
                        child: Text('Подтвердить'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _updateBookings(booking['id'], 'cancelled'),
                        child: Text('Отменить'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
