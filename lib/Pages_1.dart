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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/фон.png'),
          fit: BoxFit.cover,
        ),
      ),

      child: Scaffold(
        drawer: _dialogMenu(context),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            _buildHeader(context, isMobile),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Утренний кот',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 600
                          ? 100
                          : 55,
                      color: Color.fromARGB(255, 255, 252, 231),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width > 600 ? 50 : 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 600
                          ? 100
                          : 25,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Стресс на работе? Погода не радует? Приходи в наше уютное кафе — здесь тебя ждут сладкие десерты, кофе и мурчащие коты!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 600
                            ? 30
                            : 20,
                        color: Color.fromARGB(255, 255, 252, 231),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width > 600 ? 70 : 30,
                    ),
                  ),
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
                      child: Text(
                        'ЗАБРОНИРОВАТЬ',
                        style: TextStyle(color: Color(0xFF3A2B28)),
                      ),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 600
                              ? 30
                              : 25,
                        ),
                        backgroundColor: Color.fromARGB(255, 255, 252, 231),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width > 600
                              ? 25
                              : 20,
                          vertical: MediaQuery.of(context).size.width > 600
                              ? 30
                              : 25,
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
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 20,
          vertical: isMobile ? 30 : 20,
        ),
        color: Color(0xFF3A2B28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: isMobile ? 45 : 50,
              height: isMobile ? 45 : 50,
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isMobile) ...[
                    _menuButton('Главная', isMobile),
                    _menuButton('О нас', isMobile),
                    _menuButton('Поддержать', isMobile),
                    _menuButton('Меню', isMobile),
                    _menuButton('Контакты', isMobile),
                  ]
                ],
              ),
            ),
            if (isMobile)
              Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu, color: Color.fromARGB(255, 255, 252, 231)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(String title, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 20),
      child: TextButton(
        onPressed: () {},
        child: Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 15 : 20,
            color: Color.fromARGB(255, 255, 252, 231),
          ),
        ),
      ),
    );
  }

  Widget _dialogMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF3A2B28)),
            child: Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
          ),
          ListTile(
            title: Text('Главная'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(title: Text('О нас'), onTap: () => Navigator.pop(context)),

          ListTile(
            title: Text('Поддержать'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(title: Text('Меню'), onTap: () => Navigator.pop(context)),
          ListTile(
            title: Text('Контакты'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
