import 'package:flutter/material.dart';
import 'Pages2_bron.dart';
import 'SiteHeader.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({super.key});

  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        key: _scaffoldKey,
        drawer: _dialogMenu(context),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: HeaderSite(
                isMobile: isMobile,
                onMenuTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => BronScreen(),
                        ),
                      );
                    },
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
                    child: Text(
                      'ЗАБРОНИРОВАТЬ',
                      style: TextStyle(color: Color(0xFF3A2B28)),
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
