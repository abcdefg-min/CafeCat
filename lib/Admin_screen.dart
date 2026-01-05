import 'dart:convert';
import 'widgets/SiteHeaderAdmin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cafe/widgets/SiteHeader.dart';
import 'package:http/http.dart' as http;
import 'Pages_1.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<Map<String, dynamic>> bookings = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      drawer: _dialogMenu(context),
      backgroundColor: Color.fromARGB(255, 229, 217, 201),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return SingleChildScrollView(
            child: Column(
              children: [
                HeaderSiteAdmin(
                  isMobile: isMobile,
                  onMenuTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24.0 : 120.0,
                    vertical: isMobile ? 40.0 : 80.0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Админ-панель: Бронирование',
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A2B28),
                        ),
                      ),
                      SizedBox(height: isMobile ? 20 : 40),

                      if (bookings.isEmpty)
                        Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            'Нет активных бронирований',
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 24,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
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
                                          onPressed: () => _updateBookings(
                                            booking['id'],
                                            'confirmed',
                                          ),
                                          child: Text('Подтвердить'),
                                        ),
                                        SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () => _updateBookings(
                                            booking['id'],
                                            'cancelled',
                                          ),
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
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // appBar: AppBar(
      //   title: Text('Админ-панель'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () {
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(builder: (context) => PagesScreen()),
      //         );
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  Widget _dialogMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF3A2B28)),
            child: Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
          ),
          ListTile(
            title: Text('Главная'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PagesScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Котики'),
            onTap: () {
              //добавить
            },
          ),
        ],
      ),
    );
  }
}
