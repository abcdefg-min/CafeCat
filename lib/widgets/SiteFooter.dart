import 'package:flutter/material.dart';

class FooterScreen extends StatelessWidget {
  const FooterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return _WidgetMobile(context);
    }
    return _WidgetDesktop(context);
  }
}

Widget _WidgetDesktop(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(30),
    color: Color(0xFF3A2B28),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Image.asset('assets/images/logo.png', width: 60),
                SizedBox(height: 10),
                Text(
                  'Котокафе "Утренний кот"',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Часы работы',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  'Пн-Чт: 10:00–20:00',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  'Пт-Вс: 10:00–22:00',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Контакты',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  '+7 (900) 000-00-00',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  'info@catcafe11.ru',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 30),
        Text(
          '© 2025 Котокафе "Утренний кот". Все права защищены.',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    ),
  );
}

Widget _WidgetMobile(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(20),
    color: Color(0xFF3A2B28),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Image.asset('assets/images/logo.png', width: 60),
            SizedBox(height: 10),
            Text(
              'Котокафе "Утренний кот"',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Часы работы',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              'Пн-Чт: 10:00–20:00',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              'Пт-Вс: 10:00–22:00',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Контакты',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              '+7 (900) 000-00-00',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              'info@catcafe11.ru',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          '© 2025 Котокафе "Утренний кот". Все права защищены.',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    ),
  );
}
