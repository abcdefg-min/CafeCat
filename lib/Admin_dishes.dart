import 'package:flutter/material.dart';

class AdminDishesScreen extends StatelessWidget {
  final bool isMobile;

  const AdminDishesScreen({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: isMobile ? 15 : 20),
        Text(
          'Управление блюдами дня',
          style: TextStyle(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3A2B28),
          ),
        ),
        SizedBox(height: isMobile ? 20 : 30),
        // Здесь будет список и форма для редактирования блюд
        Placeholder(
          fallbackHeight: 300,
        ),
      ],
    );
  }
}