import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminScreenDailyMenus extends StatefulWidget {
  final bool isMobile;

  const AdminScreenDailyMenus({super.key, required this.isMobile});

  @override
  State<AdminScreenDailyMenus> createState() => _AdminScreenDailyMenusState();
}

class _AdminScreenDailyMenusState extends State<AdminScreenDailyMenus> {
  List<Map<String, dynamic>> dishes = [];
  List<Map<String, dynamic>> dailyMenus = [];
  List<Map<String, dynamic>> filteredDishes = [];

  bool isLoading = true;
  bool isLoadingMenus = true;

  //для выбора даты
  DateTime selectedDate = DateTime.now();
  String selectedDateStr = '';

  //для фильтрации блюд
  String selectedCategory = 'Все';
  final List<String> categories = ['Все', 'завтрак', 'обед', 'ужин'];

  List<String> selectedDishIds = [];

  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    selectedDateStr = DateFormat('yyyy-MM-DD').format(selectedDate);
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadDishes(), _loadDailyMenus()]);
    await _loadMenuForDate(selectedDateStr);
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
          filteredDishes = dishes;
        });
      } else {
        throw Exception('Сервер вернул статус: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка загрузки столов $e');
      _showError('Не удалось загрузить блюда');
    }
  }

  Future<void> _loadDailyMenus() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/daily-menus'),
      );
      if (response.statusCode == 200) {
        final menusJson = jsonDecode(response.body) as List;
        setState(() {
          dailyMenus = menusJson
              .map((item) => item as Map<String, dynamic>)
              .toList();
          isLoadingMenus = false;
        });
      } else {
        throw Exception('Сервер вернул статус: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка загрузки меню: $e');
      _showError('Не удалось загрузить меню на день');
      setState(() {
        isLoadingMenus = false;
      });
    }
  }

  Future<void> _loadMenuForDate(String date) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/daily-menus/$date'),
      );

      if (response.statusCode == 200) {
        final menuData = jsonDecode(response.body);
        setState(() {
          selectedDishIds = List<String>.from(menuData['dishes_of_day'] ?? []);
        });
      } else if (response.statusCode == 404) {
        // Меню на эту дату не существует
        setState(() {
          selectedDishIds = [];
        });
      }
    } catch (e) {
      print('Ошибка загрузки меню для даты: $e');
      setState(() {
        selectedDishIds = [];
      });
    }
  }

  Future<void> _saveDailyMenu() async {
    if (selectedDishIds.isEmpty) {
      _showError('Выберите хотя бы одно блюдо');
      return;
    }

    final menuData = {
      'menu_date': selectedDateStr,
      'dishes_of_day': selectedDishIds,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/daily-menus'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(menuData),
      );

      print('Ответ сервера: ${response.statusCode}');
      print('Тело ответа: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _showSuccess(responseData['message'] ?? 'Меню сохранено');
        await _loadDailyMenus();
      } else {
        final errorData = jsonDecode(response.body);
        _showError(
          'Ошибка ${response.statusCode}: ${errorData['error'] ?? 'Неизвестная ошибка'}',
        );
      }
    } catch (e) {
      print('Ошибка сохранения меню: $e');
      _showError('Ошибка сети: $e');
    }
  }

  Future<void> _updateDailyMenu() async {
    if (selectedDishIds.isEmpty) {
      _showError('Выберите хотя бы одно блюдо');
      return;
    }

    final menuData = {'dishes_of_day': selectedDishIds};

    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/daily-menus/$selectedDateStr'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(menuData),
      );

      print('Ответ сервера: ${response.statusCode}');
      print('Тело ответа: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _showSuccess(responseData['message'] ?? 'Меню обновлено');
        await _loadDailyMenus();
      } else {
        final errorData = jsonDecode(response.body);
        _showError(
          'Ошибка ${response.statusCode}: ${errorData['error'] ?? 'Неизвестная ошибка'}',
        );
      }
    } catch (e) {
      print('Ошибка обновления меню: $e');
      _showError('Ошибка сети: $e');
    }
  }

  Future<void> _deleteDailyMenu(String date) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/daily-menus/$date'),
      );

      if (response.statusCode == 200) {
        _showSuccess('Меню удалено');
        await _loadDailyMenus();
        if (date == selectedDateStr) {
          setState(() {
            selectedDishIds = [];
          });
        }
      }
    } catch (e) {
      print('Ошибка удаления меню: $e');
      _showError('Ошибка: $e');
    }
  }

  void _filterDishes() {
    setState(() {
      filteredDishes = dishes.where((dish) {
        final matchesCategory =
            selectedCategory == 'Все' || dish['category'] == selectedCategory;

        final matchesSearch =
            _searchController.text.isEmpty ||
            (dish['name'] as String).toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _toggleDishSelection(String dishId) {
    setState(() {
      if (selectedDishIds.contains(dishId)) {
        selectedDishIds.remove(dishId);
      } else {
        selectedDishIds.add(dishId);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF3A2B28)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedDateStr = DateFormat('yyyy-MM-dd').format(picked);
      });
      await _loadMenuForDate(selectedDateStr);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
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
            'Выбор блюд на день',
            style: TextStyle(
              fontSize: widget.isMobile ? 20 : 35,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3A2B28),
            ),
          ),
          SizedBox(height: widget.isMobile ? 15 : 25),

          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выберите дату',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xFF3A2B28),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            DateFormat('dd.MM.yyyy').format(selectedDate),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: Icon(Icons.calendar_today),
                        label: Text('Выбрать дату'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 185, 163, 159),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _saveDailyMenu,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Сохранить меню',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _updateDailyMenu,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3A2B28),
                        ),
                        child: Text(
                          'Обновить меню',
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
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выбранные блюда на данную дату',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3A2B28),
                    ),
                  ),
                  SizedBox(height: 15),
                  selectedDishIds.isEmpty
                      ? const Center(
                          child: Text(
                            'Блюда не выбраны',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedDishIds.map((dishId) {
                            final dish = dishes.firstWhere(
                              (d) => d['id'] == dishId,
                              orElse: () => {},
                            );

                            if (dish.isEmpty) {
                              return Container();
                            }

                            return Chip(
                              label: Text(dish['name'] ?? ''),
                              onDeleted: () => _toggleDishSelection(dishId),
                              backgroundColor: const Color(0xFF3A2B28),
                              deleteIconColor: Colors.white,
                              labelStyle: const TextStyle(color: Colors.white),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          // Список доступных блюд
          Text(
            'Доступные блюда',
            style: TextStyle(
              fontSize: widget.isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3A2B28),
            ),
          ),
          SizedBox(height: 16),
          filteredDishes.isEmpty
              ? const Center(child: Text('Нет блюд для отображения'))
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.isMobile ? 1 : 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: widget.isMobile ? 3 : 2,
                  ),
                  itemCount: filteredDishes.length,
                  itemBuilder: (context, index) {
                    final dish = filteredDishes[index];
                    final isSelected = selectedDishIds.contains(dish['id']);
                    final price = dish['price'] is double
                        ? dish['price']
                        : double.tryParse(dish['price']?.toString() ?? '0') ??
                              0;

                    return Card(
                      elevation: 2,
                      color: isSelected
                          ? const Color(0xFF3A2B28).withOpacity(0.1)
                          : null,
                      child: InkWell(
                        onTap: () => _toggleDishSelection(dish['id']),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (value) =>
                                    _toggleDishSelection(dish['id']),
                              ),
                              SizedBox(width: 8),

                              // Изображение блюда
                              if (dish['images_url'] != null &&
                                  dish['images_url'].isNotEmpty)
                                ClipRRect(
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
                              else
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.fastfood),
                                ),

                              SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      dish['name'] ?? 'Без названия',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF3A2B28),
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Категория: ${dish['category']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      '${price.toStringAsFixed(2)} ₽',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          SizedBox(height: 40),
          // Список сохраненных меню
          Text(
            'Сохраненные меню на день',
            style: TextStyle(
              fontSize: widget.isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3A2B28),
            ),
          ),
          SizedBox(height: 16),

          isLoadingMenus
              ? const Center(child: CircularProgressIndicator())
              : dailyMenus.isEmpty
              ? const Center(child: Text('Нет сохраненных меню'))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dailyMenus.length,
                  itemBuilder: (context, index) {
                    final menu = dailyMenus[index];
                    final menuDate = menu['menu_date'];
                    final dishesOfDay = List<String>.from(
                      menu['dishes_of_day'] ?? [],
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: const Icon(
                          Icons.restaurant_menu,
                          color: Color(0xFF3A2B28),
                          size: 40,
                        ),
                        title: Text(
                          DateFormat(
                            'dd.MM.yyyy',
                          ).format(DateTime.parse(menuDate)),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A2B28),
                          ),
                        ),
                        subtitle: Text('Блюд выбрано: ${dishesOfDay.length}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                setState(() {
                                  selectedDate = DateTime.parse(menuDate);
                                  selectedDateStr = menuDate;
                                  selectedDishIds = List.from(dishesOfDay);
                                });
                                // Прокручиваем к верху
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  Scrollable.ensureVisible(
                                    context,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Удалить меню?'),
                                  content: Text(
                                    'Вы уверены, что хотите удалить меню на ${DateFormat('dd.MM.yyyy').format(DateTime.parse(menuDate))}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Отмена'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteDailyMenu(menuDate);
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
    _searchController.dispose();
    super.dispose();
  }
}
