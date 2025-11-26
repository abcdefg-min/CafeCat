import 'package:flutter/material.dart';
import 'Pages_1.dart';

class BronScreen extends StatefulWidget {
  const BronScreen({super.key});

  @override
  State<BronScreen> createState() => _BronScreenState();
}

class _BronScreenState extends State<BronScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/фон2.jpg'),
          fit: BoxFit.contain,
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

            Padding(padding: EdgeInsets.all(80)),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Форма бронирования',
                    style: TextStyle(fontSize: 50, color: Color(0xFF3A2B28)),
                  ),

                  //поле для ввода имени
                  Padding(padding: EdgeInsets.all(20)),
                  SizedBox(
                    width: 900,
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 252, 231),
                            width: 3.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF3A2B28),
                            width: 3.0,
                          ),
                        ),
                        hintText: "Имя",
                      ),
                    ),
                  ),

                  //поле для ввода телефона
                  Padding(padding: EdgeInsets.all(20)),
                  SizedBox(
                    width: 900,
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 252, 231),
                            width: 3.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF3A2B28),
                            width: 3.0,
                          ),
                        ),
                        hintText: "Телефон",
                      ),
                    ),
                  ),

                  //поле для ввода почты
                  Padding(padding: EdgeInsets.all(20)),
                  SizedBox(
                    width: 900,
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 252, 231),
                            width: 3.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF3A2B28),
                            width: 3.0,
                          ),
                        ),
                        hintText: "Почта",
                      ),
                    ),
                  ),

                  //КНОПКА "ДАЛЕЕ"
                  Padding(padding: EdgeInsets.all(40)),
                  Container(
                    child: ElevatedButton(
                      onPressed: _showAlertDialog,
                      child: Text(
                        'ДАЛЕЕ',
                        style: TextStyle(color: Color(0xFF3A2B28)),
                      ),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 30),
                        backgroundColor: Color.fromARGB(255, 255, 252, 231),
                        elevation: 5,
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          left: 40,
                          right: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //backgroundColor: Colors.blueGrey,
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Форма брони',
            style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 255, 252, 231),
            ),
          ),
          content: SizedBox(
            width: 900,
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //поле для ввода даты
                Padding(padding: EdgeInsets.all(20)),
                SizedBox(
                  width: 900,
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 252, 231),
                          width: 3.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF3A2B28),
                          width: 3.0,
                        ),
                      ),
                      hintText: "Имя",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 252, 231),
                      ),
                    ),
                  ),
                ),

                //поле для ввода времени
                Padding(padding: EdgeInsets.all(20)),
                SizedBox(
                  width: 900,
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 252, 231),
                          width: 3.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF3A2B28),
                          width: 3.0,
                        ),
                      ),
                      hintText: "Время",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 252, 231),
                      ),
                    ),
                  ),
                ),

                //поле для ввода кл-ва гостей
                Padding(padding: EdgeInsets.all(20)),
                SizedBox(
                  width: 900,
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 252, 231),
                          width: 3.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF3A2B28),
                          width: 3.0,
                        ),
                      ),
                      hintText: "Количество гостей",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 252, 231),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Color.fromARGB(188, 58, 43, 40),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('ДАЛЕЕ', style: TextStyle(fontSize: 25)),
              ),
            ),
          ],
        );
      },
    );
  }
}
