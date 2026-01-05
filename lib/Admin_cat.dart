import 'package:flutter/material.dart';

class AdminCatScreen extends StatelessWidget {
  final bool isMobile;

  const AdminCatScreen({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Управление котами',
          style: TextStyle(
            fontSize: isMobile ? 20 : 35,
            color: Color(0xFF3A2B28),
          ),
        ),
        SizedBox(height: isMobile ? 15 : 25),
        //добавить список котов и форму для редактирования
        Placeholder(
          fallbackHeight: 300,
        )
      ],
    );
  }
}
