import 'package:flutter/material.dart';
import 'package:flutter_cafe/Pages2_bron.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 100, horizontal: isMobile ? 60 : 150),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/фон.png'),
          fit: BoxFit.cover
        )
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'Котокафе\n"Утренний кот"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 55 : 100,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 252, 231),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 50),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 600 ? 100 : 25,
            ),
          ),
          Text(
            'Стресс на работе? Погода не радует? Приходи в наше уютное кафе — здесь тебя ждут сладкие десерты, кофе и мурчащие коты!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 20 : 30,
              color: Color.fromARGB(255, 255, 252, 231),
            ),
          ),
          SizedBox(height: isMobile ? 30 : 100),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BronScreen()),
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
            child: Text('ЗАБРОНИРОВАТЬ'),
          ),
          Padding(padding: EdgeInsets.only(bottom: 150))
        ],
      ),
    );
  }
}
