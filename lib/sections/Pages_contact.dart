import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.only(
        top: isMobile ? 40 : 130,
        left: isMobile ? 20 : 250,
        right: isMobile ? 20 : 250,
        bottom: isMobile ? 50 : 250,
      ),
      //margin: EdgeInsets.only(bottom: isMobile ? 20 : 40),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/фон2.jpg'),
          fit: BoxFit.cover,
        ),
        color: Colors.white.withOpacity(0.95),

        //borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Наши контакты',
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A2B28),
              ),
            ),
            SizedBox(height: isMobile ? 20 : 60),
            Image.asset(
              'images/contact.png', // ← Замените на вашу карту
              height: isMobile ? 150 : 400,
              fit: BoxFit.cover,
            ),

            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: Color(0xFF3A2B28)),
                SizedBox(width: 10),
                Text(
                  'г. Чебоксары\nул. Пирогова, д. 3',
                  style: TextStyle(fontSize: isMobile ? 14 : 21),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, color: Color(0xFF3A2B28)),
                SizedBox(width: 10),
                Text(
                  '+7 (900) 000-00-00',
                  style: TextStyle(fontSize: isMobile ? 14 : 21),
                ),
              ],
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, color: Color(0xFF3A2B28)),
                SizedBox(width: 10),
                Text(
                  'info@catcafe2311.ru',
                  style: TextStyle(fontSize: isMobile ? 14 : 21),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
