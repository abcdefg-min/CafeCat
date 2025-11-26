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
                            onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (BuildContext context) => PagesScreen())
                              );
                            },
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
                      onPressed: _showDialogOneTwo,

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
                      //текст
                      child: Text(
                        'ДАЛЕЕ',
                        style: TextStyle(color: Color(0xFF3A2B28)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //всплывающие окна (2 штуки)
  void _showDialogOneTwo() {
    showDialog(
      context: context,
      builder: (context) {
        int step = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Color.fromARGB(214, 58, 43, 40),
              child: Container(
                height: 600,
                width: 900,
                padding: EdgeInsets.all(20),
                child: step == 0
                    ? _showDialogOne(() {
                        setState(() {
                          step = 1;
                        });
                      })
                    : _showDialogTwo(() {
                        setState(() {
                          step = 0;
                        });
                      }),
              ),
            );
          },
        );
      },
    );
  }

  Widget _showDialogOne(VoidCallback setState) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 40)),
        Text(
          'Форма брони',
          style: TextStyle(
            fontSize: 40,
            color: Color.fromARGB(255, 255, 252, 231),
          ),
        ),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //поле для ввода даты
              Padding(padding: EdgeInsets.all(20)),
              SizedBox(
                width: 700,
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
                width: 700,
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
                width: 700,
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

              Padding(padding: EdgeInsets.all(30)),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    setState();
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 30),
                    backgroundColor: Color.fromARGB(255, 255, 252, 231),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text(
                    'ДАЛЕЕ',
                    style: TextStyle(color: Color(0xFF3A2B28)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //2 диалоговое окно для выбора доступного столика
  Widget _showDialogTwo(VoidCallback setState) {
    return Center(
      child: Column(
        children: [
          Text(
            'Выбор доступного столика',
            style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 255, 252, 231),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          SizedBox(
            width: 500,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/столы.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(30)),
          Container(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => BronScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 30),
                backgroundColor: Color.fromARGB(255, 255, 252, 231),
                elevation: 5,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Забронировать',
                style: TextStyle(color: Color(0xFF3A2B28)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
