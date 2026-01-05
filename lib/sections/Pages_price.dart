import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.only(
        top: isMobile ? 40 : 140,
        left: isMobile ? 20 : 250,
        right: isMobile ? 20 : 250,
        bottom: isMobile ? 50 : 250,
      ),
      //margin: EdgeInsets.only(bottom: isMobile ? 20 : 40),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/фон2.jpg"),
          fit: BoxFit.contain,
        ),
        color: Color.fromARGB(255, 229, 217, 201),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Цены',
              style: TextStyle(
                fontSize: isMobile ? 24 : 45,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A2B28),
              ),
            ),
            SizedBox(height: isMobile ? 20 : 50),
            Text(
              'У нас всё прозрачно и по-домашнему уютно — вы платите не за общение с котиками, а за время, проведённое в нашем пространстве.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 16 : 25,
                color: Color(0xFF3A2B28),
              ),
            ),

            SizedBox(height: 70),
            Text(
              'Стоимость на человека',
              style: TextStyle(
                fontSize: isMobile ? 16 : 23,
                color: Color(0xFF3A2B28),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPriceCard('1 час', '400 руб', isMobile),
                  SizedBox(width: 50),
                  _buildPriceCard('2 часа', '600 руб', isMobile),
                  SizedBox(width: 50),
                  _buildPriceCard('Дети до 7 лет', 'бесплатно', isMobile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(String title, String price, bool isMobile) {
    return Container(
      width: isMobile ? 300 : 300,
      height: isMobile ? 190 : 190,
      //padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 40),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/cardPrice.jpg"),
          fit: BoxFit.contain,
        ),
        //color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 30),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, color: Color(0xFF3A2B28)),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 130, right: 40),
            child: Text(
              price,
              style: TextStyle(fontSize: 30, color: Color(0xFF3A2B28)),
            ),
          ),
        ],
      ),
    );
  }
}
