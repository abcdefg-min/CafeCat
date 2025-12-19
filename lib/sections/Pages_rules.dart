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
        bottom: isMobile ? 50 : 140,
      ),

      //margin: EdgeInsets.only(bottom: isMobile ? 20 : 10),
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage('assets/images/фон3.jpg'),
        //   fit: BoxFit.cover
        // ),
        color: Color.fromARGB(255, 229, 217, 201),

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
              fontSize: isMobile ? 16 : 20,
              color: Color(0xFF3A2B28),
            ),
            
          ),
          Padding(padding: EdgeInsets.all(isMobile ? 30 : 50)),
          SizedBox(
            height: isMobile ? 100 : 200,
            width: 1200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPriceCard(
                    'Не буди спящих котиков — они тоже любят поспать',
                    isMobile,
                  ),
                  SizedBox(width: 20),
                  _buildPriceCard(
                    'Не корми со стола - у них свой рацион',
                    isMobile,
                  ),
                  SizedBox(width: 20),
                  _buildPriceCard(
                    'Гладим аккуратно - если кошка ушла, ненастаиваем',
                    isMobile,
                  ),
                  SizedBox(width: 20),
                  _buildPriceCard(
                    'Дети - под присмотром - чтобы игра была безопасной для всех',
                    isMobile,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(String title, bool isMobile) {
    return Container(
      width: isMobile ? 200 : 700,
      height: isMobile ? 200 : 120,
      decoration: BoxDecoration(
        color: Color(0xFF3A2B28),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 13 : 25,
              color: Color.fromARGB(255, 229, 217, 201),
            ),
          ),
        ],
        
      ),
    );
  }
}
