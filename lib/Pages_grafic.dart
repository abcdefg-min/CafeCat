// lib/sections/working_hours_section.dart
import 'package:flutter/material.dart';

class GraficScreen extends StatelessWidget {
  const GraficScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: isMobile ? 20 : 40,
      ),
      // Полупрозрачный фон, чтобы текст читался на фоне
      decoration: BoxDecoration(
        color: Color(0xFF3A2B28).withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'График работы',
            style: TextStyle(
              fontSize: isMobile ? 28 : 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 15 : 25),
          Text(
            'Понедельник - Пятница\n9:00 - 18:00',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 10 : 15),
          Text(
            'Суббота - Воскресенье\n11:00 - 15:00',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}