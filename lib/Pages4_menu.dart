import 'package:flutter/material.dart';
import 'package:flutter_cafe/SiteHeader.dart';
import 'Pages_1.dart';
import 'Pages3_cat.dart';

const double KHeaderHeight = 80.0;

class MenuPagesScreen extends StatefulWidget {
  const MenuPagesScreen({super.key});

  @override
  State<MenuPagesScreen> createState() => _MenuPagesScreenState();
}

class _MenuPagesScreenState extends State<MenuPagesScreen> {
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

            Builder(builder: (context) {
              final isMobile = MediaQuery.of(context).size.width < 600;
                final horizontalPadding = isMobile ? 24.0 : 120.0;

                return Padding(
                  padding: EdgeInsets.only(
                    top: KHeaderHeight + 80,
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: 20,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Меню')
                    ],
                  ),
                );
            })
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
