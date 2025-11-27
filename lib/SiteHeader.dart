import 'package:flutter/material.dart';

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
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
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
                    _menuButton('Котики', isMobile),
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