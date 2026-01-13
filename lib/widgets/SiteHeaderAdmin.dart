import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  final int currentTab;
  final Function(int) onTabChanged;
  final bool isMobile;
  final BuildContext parentContext; // Добавляем контекст

  const AdminHeader({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
    required this.isMobile,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3A2B28),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.0 : 40.0,
          vertical: isMobile ? 12.0 : 16.0,
        ),
        child: isMobile 
            ? _buildMobileHeader(parentContext)
            : _buildDesktopHeader(parentContext),
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 50,
              height: 50,
            ),
            
          ],
        ),
        
        Expanded(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTabButton(0, 'Бронирования', Icons.calendar_today),
                SizedBox(width: 16),
                _buildTabButton(1, 'Коты', Icons.pets),
                SizedBox(width: 16),
                _buildTabButton(2, 'Блюда дня', Icons.restaurant),
                SizedBox(width: 16),
                _buildTabButton(3, 'Выбор блюд на день', Icons.restaurant_menu_outlined),
              ],
            ),
          ),
        ),
        
        IconButton(
          icon: Icon(Icons.exit_to_app, color: Color.fromARGB(255, 229, 217, 201), size: 30),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          tooltip: 'Выход',
        ),
      ],
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 10),
                Text(
                  'Админ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.white, size: 20),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
        
        SizedBox(height: 12),
        
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTabButton(0, 'Брони', Icons.calendar_today),
              SizedBox(width: 12),
              _buildTabButton(1, 'Коты', Icons.pets),
              SizedBox(width: 12),
              _buildTabButton(2, 'Добавление блюд', Icons.restaurant),
              SizedBox(width: 12),
              _buildTabButton(3, 'Выбор блюд дня', Icons.restaurant_menu_outlined),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(int tabIndex, String title, IconData icon) {
    final isSelected = currentTab == tabIndex;
    
    return Container(
      decoration: isSelected
          ? BoxDecoration(
              color: Color.fromARGB(255, 229, 217, 201),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color.fromARGB(255, 229, 217, 201),
              ),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white54,
              ),
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTabChanged(tabIndex),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 8 : 10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: isMobile ? 16 : 20,
                  color: isSelected ? Color(0xFF3A2B28) : Colors.white,
                ),
                SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Color(0xFF3A2B28) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}