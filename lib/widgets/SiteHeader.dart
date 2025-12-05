import 'package:flutter/material.dart';
import '../Pages3_cat.dart';
import '../Pages_1.dart';
import '../Pages4_menu.dart';
import '../Pages5_contact.dart';
import '../sections/Pages_contact.dart';

class HeaderSite extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onMenuTap;

  const HeaderSite({
    super.key,
    required this.isMobile,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Color(0xFF3A2B28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: isMobile ? 45 : 50,
            height: isMobile ? 45 : 50,
          ),

          if (!isMobile)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _navButton('Главная', () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => PagesScreen())
                    );
                  }, isMobile),
                  _navButton('Котики', () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => CatScreen())
                    );
                  }, isMobile),
                  _navButton('Меню', () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => MenuPagesScreen())
                    );
                  }, isMobile),
                  _navButton('Контакты', () {
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => ScreenContact())
                    );
                  }, isMobile),
                ],
              ),
            ),
            if (isMobile) IconButton(
              onPressed: onMenuTap, 
              icon: Icon(Icons.menu, color: Color.fromARGB(255, 255, 252, 231)),
            )
        ],
      ),
    );
  }

  Widget _navButton(String title, VoidCallback onPressed, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 20),
      child: TextButton(
        onPressed: onPressed,
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

}
