import 'package:flutter/material.dart';
import 'Pages_admin.dart';
import 'Pages_1.dart';

class VyborScreen extends StatefulWidget {
  const VyborScreen({super.key});

  @override
  State<VyborScreen> createState() => _VyborScreenState();
}

class _VyborScreenState extends State<VyborScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => AdminScreen())
              );
            }, 
            child: Text('Администратор', style: TextStyle(
              fontSize: 20,
            ),),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => PagesScreen())
              );
            }, 
            child: Text('Клиент', style: TextStyle(
              fontSize: 20,
            ),),
          ),
        ],
      ),
    );
  }
}