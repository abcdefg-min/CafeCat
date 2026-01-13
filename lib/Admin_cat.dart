import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminCatScreen extends StatefulWidget {
  final bool isMobile;

  const AdminCatScreen({super.key, required this.isMobile});

  @override
  State<AdminCatScreen> createState() => _AdminCatScreenState();
}

class _AdminCatScreenState extends State<AdminCatScreen> {
  List<Map<String, dynamic>> cats = [];
  bool isLoading = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _hoverUrlController = TextEditingController();
  String? _editingCatId;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadCats();
  }

  Future<void> _loadCats() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/cats'),
      );
      if (response.statusCode == 200) {
        final catsJson = jsonDecode(response.body) as List;
        setState(() {
          cats = catsJson.map((item) => item as Map<String, dynamic>).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Сервер вернул статус: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка загрузки котов: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось загрузить котов')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveCat() async {
    print('Сохраняем кота, ID: $_editingCatId');
    print('Данные: имя=${_nameController.text}, пол=${_genderController.text}');

    if (_nameController.text.isEmpty || _genderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните обязательные поля')),
      );
      return;
    }

    final catData = {
      'name': _nameController.text,
      'gender': _genderController.text,
      'description': _descriptionController.text,
      'image_url': _imageUrlController.text,
      'hover_url': _hoverUrlController.text,
    };

    try {
      if (_isEditing && _editingCatId != null) {
        // Обновление существующего кота
        final response = await http.put(
          Uri.parse('http://localhost:3000/api/cats/$_editingCatId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(catData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Кот обновлен')));
          _resetForm();
          await _loadCats();
        }
      } else {
        // Создание нового кота
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/cats'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(catData),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Кот добавлен')));
          _resetForm();
          await _loadCats();
        }
      }
    } catch (e) {
      print('Ошибка сохранения кота: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  Future<void> _deleteCat(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/cats/$id'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Кот удален')));
        await _loadCats();
      }
    } catch (e) {
      print('Ошибка удаления кота: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  void _editCat(Map<String, dynamic> cat) {
    setState(() {
      _isEditing = true;
      _editingCatId = cat['id'];
      _nameController.text = cat['name'] ?? '';
      _genderController.text = cat['gender'] ?? '';
      _descriptionController.text = cat['description'] ?? '';
      _imageUrlController.text = cat['image_url'] ?? '';
      _hoverUrlController.text = cat['hover_url'] ?? '';
    });
  }

  void _resetForm() {
    setState(() {
      _isEditing = false;
      _editingCatId = null;
      _nameController.clear();
      _genderController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();
      _hoverUrlController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: widget.isMobile ? 15 : 20),
          Text(
            'Управление котами',
            style: TextStyle(
              fontSize: widget.isMobile ? 20 : 35,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3A2B28),
            ),
          ),
          SizedBox(height: widget.isMobile ? 15 : 25),

          // Форма для добавления/редактирования
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEditing ? 'Редактировать кота' : 'Добавить нового кота',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, 
                      color: const Color(0xFF3A2B28),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя кота*',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _genderController,
                    decoration: const InputDecoration(
                      labelText: 'Пол* (самец/самка)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL основной картинки',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _hoverUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL картинки при наведении',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _saveCat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A2B28),
                        ),
                        child: Text(
                          _isEditing ? 'Сохранить' : 'Добавить',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      if (_isEditing)
                        ElevatedButton(
                          onPressed: _resetForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text(
                            'Отмена',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 30),

          // Список котов
          Text(
            'Список котов',
            style: TextStyle(
              fontSize: widget.isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3A2B28),
            ),
          ),
          SizedBox(height: 16),

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : cats.isEmpty
              ? const Center(child: Text('Нет котов для отображения'))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cats.length,
                  itemBuilder: (context, index) {
                    final cat = cats[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: cat['image_url'] != null
                              ? NetworkImage(cat['image_url'] as String)
                              : const AssetImage(
                                      'assets/images/default_cat.png',
                                    )
                                    as ImageProvider,
                        ),
                        title: Text(
                          cat['name'] ?? 'Без имени',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A2B28),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Пол: ${cat['gender']}'),
                            if (cat['description'] != null)
                              Text(
                                '${(cat['description'] as String).length > 50 ? (cat['description'] as String).substring(0, 50) + '...' : cat['description']}',
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editCat(cat),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Удалить кота?'),
                                  content: Text(
                                    'Вы уверены, что хотите удалить ${cat['name']}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Отмена'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteCat(cat['id']);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Удалить',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _hoverUrlController.dispose();
    super.dispose();
  }
}
