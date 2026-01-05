import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  final int currentTab;
  final Function(int) onTabChanged;
  final bool isMobile;

  const AdminHeader({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3A2B28),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20.0 : 120.0,
          vertical: isMobile ? 15.0 : 20.0,
        ),
        child: Column(
          children: [
            // Логотип и заголовок
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: isMobile ? 40 : 60,
                      height: isMobile ? 40 : 60,
                    ),
                    SizedBox(width: isMobile ? 10 : 20),
                    Text(
                      'Панель админа',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (!isMobile)
                  IconButton(
                    icon: Icon(Icons.exit_to_app, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
              ],
            ),

            SizedBox(height: isMobile ? 15 : 25),

            // Навигационные вкладки
            isMobile ? _buildMobileTabs() : _buildDesktopTabs(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabButton(0, 'Бронирования', Icons.calendar_today),
        SizedBox(width: 20),
        _buildTabButton(1, 'Коты', Icons.pets),
        SizedBox(width: 20),
        _buildTabButton(2, 'Блюда дня', Icons.restaurant),
      ],
    );
  }

  Widget _buildMobileTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabButton(0, 'Брони', Icons.calendar_today),
          SizedBox(width: 15),
          _buildTabButton(1, 'Коты', Icons.pets),
          SizedBox(width: 15),
          _buildTabButton(2, 'Блюда', Icons.restaurant),
        ],
      ),
    );
  }

  Widget _buildTabButton(int tabIndex, String title, IconData icon) {
    final isSelected = currentTab == tabIndex;

    return ElevatedButton.icon(
      onPressed: () => onTabChanged(tabIndex),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Color.fromARGB(255, 229, 217, 201)
            : Colors.transparent,
        foregroundColor: isSelected ? Color(0xFF3A2B28) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? Color.fromARGB(255, 229, 217, 201)
                : Colors.white54,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 20,
          vertical: isMobile ? 8 : 12,
        ),
      ),
      icon: Icon(icon, size: isMobile ? 18 : 24),
      label: Text(
        title,
        style: TextStyle(
          fontSize: isMobile ? 14 : 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
