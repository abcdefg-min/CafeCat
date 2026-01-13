import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDishesScreen extends StatefulWidget {
  final bool isMobile;

  const AdminDishesScreen({super.key, required this.isMobile});

  @override
  State<AdminDishesScreen> createState() => _AdminDishesScreenState();
}

class _AdminDishesScreenState extends State<AdminDishesScreen> {
  List<Map<String, dynamic>> dishes = [];
  

  bool isLoading = true;

  // Контроллеры для формы
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isAvailable = true;

  String? _editingDishId;
  bool _isEditing = false;

  // Список категорий для выпадающего списка 
  final List<String> _categories = ['завтрак', 'обед', 'ужин'];

  @override
  void initState() {
    super.initState();
    _loadDishes();
  }

  Future<void> _loadDishes() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/dishes'),
      );
      if (response.statusCode == 200) {
        final dishesJson = jsonDecode(response.body) as List;
        setState(() {
          dishes = dishesJson
              .map((item) => item as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Сервер вернул статус: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка загрузки блюд: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось загрузить блюда')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveDish() async {
    print('Сохраняем блюдо, ID: $_editingDishId');

    // Проверка цены
    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Введите корректную цену')));
      return;
    }

    final dishData = {
      'name': _nameController.text,
      'category': _categoryController.text,
      'price': price,
      'is_available': _isAvailable,
      'images_url': _imageUrlController.text,
    };

    try {
      if (_isEditing && _editingDishId != null) {
        // Обновление существующего блюда
        final response = await http.put(
          Uri.parse('http://localhost:3000/api/dishes/$_editingDishId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dishData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Блюдо обновлено')));
          _resetForm();
          await _loadDishes();
        }
      } else {
        // Создание нового блюда
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/dishes'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dishData),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Блюдо добавлено')));
          _resetForm();
          await _loadDishes();
        }
      }
    } catch (e) {
      print('Ошибка сохранения блюда: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  Future<void> _deleteDish(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/dishes/$id'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Блюдо удалено')));
        await _loadDishes();
      }
    } catch (e) {
      print('Ошибка удаления блюда: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  void _editDish(Map<String, dynamic> dish) {
    setState(() {
      _isEditing = true;
      _editingDishId = dish['id'];
      _nameController.text = dish['name'] ?? '';
      _categoryController.text = dish['category'] ?? '';
      _priceController.text = dish['price']?.toString() ?? '';
      _isAvailable = dish['is_available'] ?? true;
      _imageUrlController.text = dish['images_url'] ?? '';
    });
  }

  void _resetForm() {
    setState(() {
      _isEditing = false;
      _editingDishId = null;
      _nameController.clear();
      _categoryController.clear();
      _priceController.clear();
      _imageUrlController.clear();
      _isAvailable = true;
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
            'Управление блюдами',
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
                    _isEditing ? 'Редактировать блюдо' : 'Добавить новое блюдо',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3A2B28),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Название блюда
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Название блюда',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Категория (выпадающий список)
                  DropdownMenu<String>(
                    controller: _categoryController,
                    label: const Text('Категория', style: TextStyle(fontSize: 15),),
                    dropdownMenuEntries: _categories
                        .map(
                          (category) => DropdownMenuEntry(
                            value: category,
                            label: category,
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 12),

                  // Цена
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Цена',
                      suffixText: 'руб.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Доступность
                  Row(
                    children: [
                      const Text('Доступно для заказа:'),
                      SizedBox(width: 10),
                      Switch(
                        value: _isAvailable,
                        onChanged: (value) {
                          setState(() {
                            _isAvailable = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // URL изображения
                  TextField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL изображения',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Кнопки
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _saveDish,
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

          // Список блюд
          Text(
            'Список блюд',
            style: TextStyle(
              fontSize: widget.isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3A2B28),
            ),
          ),
          SizedBox(height: 16),

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : dishes.isEmpty
              ? const Center(child: Text('Нет блюд для отображения'))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dishes.length,
                  itemBuilder: (context, index) {
                    final dish = dishes[index];
                    final price = dish['price'] is double
                        ? dish['price']
                        : double.tryParse(dish['price']?.toString() ?? '0') ??
                              0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading:
                            dish['images_url'] != null &&
                                dish['images_url'].isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  dish['images_url'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.fastfood),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.fastfood),
                              ),
                        title: Text(
                          dish['name'] ?? 'Без названия',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A2B28),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Категория: ${dish['category']}'),
                            Text('Цена: ${price.toStringAsFixed(2)} ₽'),
                            Text(
                              'Доступно: ${dish['is_available'] == true ? 'Да' : 'Нет'}',
                              style: TextStyle(
                                color: dish['is_available'] == true
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editDish(dish),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Удалить блюдо?'),
                                  content: Text(
                                    'Вы уверены, что хотите удалить "${dish['name']}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Отмена'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteDish(dish['id']);
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
    _categoryController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
