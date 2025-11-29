import 'package:flutter/material.dart';
import 'sections/Pages_banner.dart';
import 'sections/Pages_contact.dart';
import 'widgets/SiteFooter.dart';
import 'sections/Pages_rules.dart';
import "widgets/SiteHeader.dart";
import 'Pages3_cat.dart';
import 'Pages4_menu.dart';

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
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _dialogMenu(context),
        body: Stack(
          children: [
            // Шапка
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: HeaderSite(
                isMobile: isMobile,
                onMenuTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),

            // Основной контент
            Positioned.fill(
              top: 80, // высота шапки
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const BannerScreen(),
                    const RulesScreen(),
                    const ContactScreen(),
                    const FooterScreen(),
                  ],
                ),
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
