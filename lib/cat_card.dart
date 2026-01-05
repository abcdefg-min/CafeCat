// widgets/cat_card.dart

import 'package:flutter/material.dart';

class CatCard extends StatefulWidget {
  final String name;
  final String gender;
  final String description;
  final String imageUrl;
  final String? imageUrlHover;

  const CatCard({
    super.key,
    required this.name,
    required this.gender,
    required this.description,
    required this.imageUrl,
    this.imageUrlHover,
  });

  @override
  State<CatCard> createState() => _CatCardState();
}

class _CatCardState extends State<CatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Для десктопа — MouseRegion, для мобильных — GestureDetector
    Widget cardWidget = Container(
      width: 250,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение кота
          Image.asset(
            _isHovered && widget.imageUrlHover != null
                ? widget.imageUrlHover!
                : widget.imageUrl,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image, size: 80, color: Colors.grey);
            },
          ),
          SizedBox(height: 12),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A2B28),
            ),
          ),
          Text(
            widget.gender,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            widget.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: Color(0xFF3A2B28)),
          ),
        ],
      ),
    );

    // Определяем, использовать ли MouseRegion или GestureDetector
    if (MediaQuery.of(context).size.width < 600) {
      // Мобильная версия — тап для смены изображения
      return GestureDetector(
        onTap: () {
          setState(() => _isHovered = !_isHovered);
        },
        child: cardWidget,
      );
    } else {
      // Десктоп — наведение мыши
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: cardWidget,
      );
    }
  }
}