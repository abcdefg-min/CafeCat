import 'package:flutter/material.dart';
import 'SiteHeader.dart';

class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  State<CatScreen> createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/фон3.jpg'),
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
                    'Наши котики',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 600
                          ? 20
                          : 50,
                      color: Color(0xFF3A2B28),
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
            title: Text('Котики'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CatScreen()),
              );
            },
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
