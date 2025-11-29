import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.only(
        top: isMobile ? 40 : 110,
        left: isMobile ? 20 : 200,
        right: isMobile ? 20 : 200,
        bottom: isMobile ? 50 : 250
      ),

      //margin: EdgeInsets.only(bottom: isMobile ? 20 : 10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/фон3.jpg'),
          fit: BoxFit.cover,
        ),
        color: Colors.white.withOpacity(0.95),

        //borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Правила посещения',
            style: TextStyle(
              fontSize: isMobile ? 24 : 50,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A2B28),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 40),
          Text(
            'Мы создали уютное место, где вы можете насладиться вкусной едой, ароматным кофе и общением с нашими котиками. Каждый гость найдёт здесь что-то себе по душе, уют и удовольствие.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: Color(0xFF3A2B28),
            ),
          ),

          SizedBox(height: isMobile ? 20 : 60),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3A2B28),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 30, vertical: isMobile ? 20 : 25),
            ),
            child: Text(
              'Не буди спящих котиков — они тоже любят поспать',
              style: TextStyle(
                fontSize: isMobile ? 13 : 21,
                color: Color.fromARGB(255, 255, 252, 231),
                ),
            ),
          ),
          SizedBox(height: isMobile ? 10 : 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3A2B28),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 30, vertical: isMobile ? 20 : 25),
            ),
            child: Text(
              'Не корми со стола - у них свой рацион',
              style: TextStyle(
                fontSize: isMobile ? 13 : 21,
                color: Color.fromARGB(255, 255, 252, 231),
                ),
            ),
          ),
          SizedBox(height: isMobile ? 10 : 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3A2B28),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 30, vertical: isMobile ? 20 : 25),
            ),
            child: Text(
              'Гладим аккуратно - если кошка ушла, ненастаиваем',
              style: TextStyle(
                fontSize: isMobile ? 13 : 21,
                color: Color.fromARGB(255, 255, 252, 231),
                ),
            ),
          ),
          SizedBox(height: isMobile ? 10 : 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3A2B28),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 30, vertical: isMobile ? 20 : 25),
            ),
            child: Text(
              'Дети - под присмотром - чтобы игра была безопасной для всех',
              style: TextStyle(
                fontSize: isMobile ? 13 : 21,
                color: Color.fromARGB(255, 255, 252, 231),
                ),
            ),
          ),
        ],
      ),
    );
  }
}
