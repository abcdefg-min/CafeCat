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
                MaterialPageRoute(builder: (context) => AdminScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 600 ? 30 : 25,
              ),
              backgroundColor: Color.fromARGB(255, 255, 252, 231),
              elevation: 5,
              foregroundColor: Color(0xFF3A2B28),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 25 : 20,
                vertical: MediaQuery.of(context).size.width > 600 ? 20 : 20,
              ),
            ),
            child: Text('Администратор', style: TextStyle(fontSize: 30)),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PagesScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 600 ? 30 : 25,
              ),
              backgroundColor: Color.fromARGB(255, 255, 252, 231),
              elevation: 5,
              foregroundColor: Color(0xFF3A2B28),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 25 : 20,
                vertical: MediaQuery.of(context).size.width > 600 ? 20 : 20,
              ),
            ),
            child: Text('Клиент', style: TextStyle(fontSize: 30)),
          ),
        ],
      ),
    );
  }
}
