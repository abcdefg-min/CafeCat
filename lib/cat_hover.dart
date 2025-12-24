import 'package:flutter/material.dart';

class CatCardHover extends StatefulWidget {
  final Map<String, dynamic> cat;
  final double itemSize;
  final VoidCallback onTap;

  const CatCardHover({
    required this.cat,
    required this.itemSize,
    required this.onTap,
  });

  @override
  State<CatCardHover> createState() => __CatCardHoverState();
}

class __CatCardHoverState extends State<CatCardHover> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    print('Hover URL for ${widget.cat['name']}: ${widget.cat['hover_url']}');
    print('Image URL for ${widget.cat['name']}: ${widget.cat['image_url']}');

    final isMobile = MediaQuery.of(context).size.width < 600;

    String imageUrl =
        _isHovered &&
            widget.cat['hover_url'] != null &&
            widget.cat['hover_url'].isNotEmpty
        ? widget.cat['hover_url']
        : widget.cat['image_url'];

    Widget cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.itemSize,
          height: widget.itemSize,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.3 : 0.2),
                blurRadius: _isHovered ? 20 : 15,
                spreadRadius: _isHovered ? 3 : 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  widget.cat['image_url'],
                  fit:  BoxFit.cover,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedDefaultTextStyle(
          style: TextStyle(
            fontSize: 20,
            color: const Color(0xFF3A2B28),
            decoration: _isHovered ? TextDecoration.none : TextDecoration.none,
          ), 
          duration: const Duration(milliseconds: 200),
          child: Text(
            widget.cat['name'],
            textAlign: TextAlign.center,
          ), 
        ),
      ],
    );
    //для моб уст
    if (isMobile) {
      return GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: cardContent,
      );
    }
    //для десктопа
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: cardContent,
      ),
    );
  }
}
