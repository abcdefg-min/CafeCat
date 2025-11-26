import 'package:flutter/material.dart';
import 'Pages2_bron.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({super.key});

  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/фон.png'),
          fit: BoxFit.cover,
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: Color(0xFF3A2B28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 50,
                      height: 50,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Главная',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 255, 252, 231),
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'О нас',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 255, 252, 231),
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Поддержать',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 255, 252, 231),
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Меню',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 255, 252, 231),
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Контакты',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 255, 252, 231),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Утренний кот',
                    style: TextStyle(
                      fontSize: 100,
                      color: Color.fromARGB(255, 255, 252, 231),
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 100),
                    alignment: Alignment.center,
                    child: Text(
                      'Стресс на работе? Погода не радует? Приходи в наше уютное кафе — здесь тебя ждут сладкие десерты, кофе и мурчащие коты!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 255, 252, 231),
                      ),
                    ),
                  
                  ),
                  Padding(padding: EdgeInsets.all(70)),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, 
                              MaterialPageRoute(
                                builder: (BuildContext context) => BronScreen(),
                              )
                        );
                      }, 
                      child: Text('ЗАБРОНИРОВАТЬ', style: TextStyle(color: Color(0xFF3A2B28))),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 30),
                        backgroundColor: Color.fromARGB(255, 255, 252, 231),
                        elevation: 5,
                        padding: EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
                      )
                    ),

                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
