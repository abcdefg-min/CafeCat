import 'package:flutter/material.dart';
import 'widgets/SiteFooter.dart';
import 'widgets/SiteHeader.dart';
import 'Pages_1.dart';
import 'Pages3_cat.dart';
import 'Pages4_menu.dart';

const double KHeaderHeight = 80.0;

class ScreenContact extends StatefulWidget {
  const ScreenContact({super.key});

  @override
  State<ScreenContact> createState() => _ScreenContactState();
}

class _ScreenContactState extends State<ScreenContact> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/фон2.jpg'),
      //     fit: BoxFit.cover,
      //   ),
      //   color: Colors.white.withOpacity(0.95),
      // ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _dialogMenu(context),
        backgroundColor: Color.fromARGB(255, 229, 217, 201),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderSite(
                isMobile: isMobile,
                onMenuTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),

              // 2. Основной контент (без Stack!)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24.0 : 120.0,
                  vertical: 40.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Наши контакты',
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A2B28),
                      ),
                    ),
                    SizedBox(height: isMobile ? 20 : 60),
                    Image.asset(
                      'images/contact.png',
                      height: isMobile ? 150 : 400,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Color(0xFF3A2B28)),
                        SizedBox(width: 10),
                        Text(
                          'г. Чебоксары\nул. Пирогова, д. 3',
                          style: TextStyle(fontSize: isMobile ? 14 : 21),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Color(0xFF3A2B28)),
                        SizedBox(width: 10),
                        Text(
                          '+7 (900) 000-00-00',
                          style: TextStyle(fontSize: isMobile ? 14 : 21),
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Color(0xFF3A2B28)),
                        SizedBox(width: 10),
                        Text(
                          'info@catcafe2311.ru',
                          style: TextStyle(fontSize: isMobile ? 14 : 21),
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),

              FooterScreen(), // ← без Container, без height!
            ],
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PagesScreen()),
              );
            },
          ),
          ListTile(title: Text('О нас'), onTap: () => Navigator.pop(context)),

          ListTile(
            title: Text('Котики'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CatScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Меню'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuPagesScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Контакты'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
