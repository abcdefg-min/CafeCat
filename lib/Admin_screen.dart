import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widgets/SiteHeaderAdmin.dart';
import 'Pages_1.dart';
import 'Admin_cat.dart';
import 'Admin_dishes.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<Map<String, dynamic>> bookings = [];
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    if (_currentTab == 0) {
      _loadBookings();
    }
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

  void _onTabChanged(int tabIndex) {
    setState(() {
      _currentTab = tabIndex;
    });
    
    // Загружаем данные в зависимости от выбранной вкладки
    if (tabIndex == 0) {
      _loadBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 217, 201),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return Column(
            children: [
              AdminHeader(
                currentTab: _currentTab,
                onTabChanged: _onTabChanged,
                isMobile: isMobile,
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24.0 : 120.0,
                      vertical: isMobile ? 20.0 : 40.0,
                    ),
                    child: _buildCurrentTabContent(isMobile),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrentTabContent(bool isMobile) {
    switch (_currentTab) {
      case 0: // Бронирования
        return _buildBookingsContent(isMobile);
      case 1: // Коты
        return AdminCatScreen(isMobile: isMobile);
      case 2: // Блюда дня
        return AdminDishesScreen(isMobile: isMobile);
      default:
        return _buildBookingsContent(isMobile);
    }
  }

  Widget _buildBookingsContent(bool isMobile) {
    return Column(
      children: [
        SizedBox(height: isMobile ? 15 : 20),
        Text(
          'Управление бронированиями',
          style: TextStyle(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3A2B28),
          ),
        ),
        SizedBox(height: isMobile ? 20 : 35),
        
        if (bookings.isEmpty)
          Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 60,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 20),
                Text(
                  'Нет активных бронирований',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        else
          isMobile 
            ? _buildMobileBookingsList()
            : _buildDesktopBookingsTable(),
      ],
    );
  }

  Widget _buildMobileBookingsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: EdgeInsets.only(bottom: 15),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            booking['phone'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(booking['status']),
                  ],
                ),
                Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Дата: ${booking['date']}'),
                        Text('Время: ${booking['time']}'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Стол: ${booking['tableId']}'),
                        Text('Гости: ${booking['guests']}'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateBookings(
                          booking['id'],
                          'confirmed',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        icon: Icon(Icons.check),
                        label: Text('Подтвердить'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateBookings(
                          booking['id'],
                          'cancelled',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        icon: Icon(Icons.close),
                        label: Text('Отменить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopBookingsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Имя')),
          DataColumn(label: Text('Телефон')),
          DataColumn(label: Text('Дата')),
          DataColumn(label: Text('Время')),
          DataColumn(label: Text('Стол')),
          DataColumn(label: Text('Гости')),
          DataColumn(label: Text('Статус')),
          DataColumn(label: Text('Действия')),
        ],
        rows: bookings.map((booking) {
          return DataRow(cells: [
            DataCell(Text(booking['name'])),
            DataCell(Text(booking['phone'])),
            DataCell(Text(booking['date'])),
            DataCell(Text(booking['time'])),
            DataCell(Text(booking['tableId'].toString())),
            DataCell(Text(booking['guests'].toString())),
            DataCell(_buildStatusBadge(booking['status'])),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () => _updateBookings(
                      booking['id'],
                      'confirmed',
                    ),
                    tooltip: 'Подтвердить',
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => _updateBookings(
                      booking['id'],
                      'cancelled',
                    ),
                    tooltip: 'Отменить',
                  ),
                ],
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = Colors.green;
        text = 'Подтверждено';
        break;
      case 'cancelled':
        color = Colors.red;
        text = 'Отменено';
        break;
      default:
        color = Colors.orange;
        text = 'Ожидание';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}