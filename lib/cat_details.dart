import 'package:flutter/material.dart';

class CatDetailDialog extends StatefulWidget {
  final Map<String, dynamic> cat;

  const CatDetailDialog({required this.cat});

  @override
  State<CatDetailDialog> createState() => __CatDetailDialogState();
}

class __CatDetailDialogState extends State<CatDetailDialog> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // ВАЖНО: используем 'hover_url' вместо 'image_hover_url'
    String imageUrl = widget.cat['image_url']; // Основное изображение

    if (_isHovered) {
      final hoverUrl = widget.cat['hover_url'];
      if (hoverUrl != null &&
          hoverUrl.toString().isNotEmpty &&
          hoverUrl != '[null]') {
        imageUrl = hoverUrl;
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 150),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Имя
              Text(
                widget.cat['name'],
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3A2B28),
                ),
              ),
              const SizedBox(height: 8),
              // Пол
              Text(
                'Пол: ${widget.cat['gender']}',
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              // Описание
              Text(
                widget.cat['description'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),
              const SizedBox(height: 20),
              // Подсказка (только если есть hover_url)
              if (widget.cat['hover_url'] != null &&
                  widget.cat['hover_url'].isNotEmpty)
                Text(
                  'Наведи курсор на фото, чтобы увидеть другую картинку',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const SizedBox(height: 20),
              // Кнопка "Закрыть"
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A2B28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Закрыть',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
