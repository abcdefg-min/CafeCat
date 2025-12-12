import 'package:flutter/material.dart';
import 'widgets/SiteHeader.dart';
import 'Pages4_menu.dart';
import 'widgets/SiteFooter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BronScreen extends StatefulWidget {
  const BronScreen({super.key});

  @override
  State<BronScreen> createState() => _BronScreenState();
}

class _BronScreenState extends State<BronScreen> {
  late final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _guestsController = TextEditingController();

  List<Map<String, dynamic>> tables = [];
  List<String> _occupiedTables = [];

  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _dateError;
  String? _timeError;
  String? _guestsError;

  Future<void> _loadTables() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/tables'),
      );

      if (response.statusCode == 200) {
        final tablesJson = jsonDecode(response.body) as List;
        setState(() {
          tables = tablesJson
              .map((item) => item as Map<String, dynamic>)
              .toList();
        });
      } else {
        throw Exception('Не удалось загрузить столы');
      }
    } catch (e) {
      print('Ошибка загрузки столов: $e');
    }
  }

  Future<void> _loadOccupiedTables(String date, String time) async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost:3000/api/occupied-tables?date=$date&time=$time',
        ),
      );

      if (response.statusCode == 200) {
        final occupied = jsonDecode(response.body) as List;
        setState(() {
          _occupiedTables = (occupied as List)
              .map((item) => item.toString())
              .toList();
        });
      } else {
        throw Exception('Не удалось загрузить занятые столы');
      }
    } catch (e) {
      print('Ошибка загрузки занятых столов: $e');
    }
  }

  Future<void> _submitBooking({
    required BuildContext dialogContext,
    required String selectedTableId,
    required int guests,
    required String name,
    required String phone,
    required String email,
    required String date,
    required String time,
  }) async {
    final bookingData = {
      'name': name,
      'phone': phone,
      'email': email,
      'date': date,
      'time': time,
      'guests': guests,
      'tableId': selectedTableId,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookingData),
      );
      if (response.statusCode == 201) {
        // Обновляем внешнее состояние
        setState(() {
          if (!_occupiedTables.contains(selectedTableId)) {
            _occupiedTables.add(selectedTableId);
          }
        });

        _resetFields();
        Navigator.of(dialogContext).pop(); // закрываем диалог
        Navigator.of(context).pop(); // возвращаемся назад (опционально)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Бронь создана')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сервера: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  void _resetFields() {
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _dateController.clear();
    _timeController.clear();
    _guestsController.clear();
  }

  bool _validatePrimaryFields() {
    bool isValid = true;
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = 'Обязательное поле';
      });
      isValid = false;
    } else {
      setState(() {
        _nameError = null;
      });
    }

    if (_phoneController.text.trim().isEmpty) {
      setState(() {
        _phoneError = 'Обязательное поле';
      });
      isValid = false;
    } else if (!RegExp(
      r'^[\+]?[0-9\s\-\(\)]{10,}$',
    ).hasMatch(_phoneController.text.trim())) {
      setState(() {
        _phoneError = 'Некорректный номер';
      });
      isValid = false;
    } else {
      setState(() {
        _phoneError = null;
      });
    }

    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = 'Обязательное поле';
      });
      isValid = false;
    } else if (!RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    ).hasMatch(_emailController.text.trim())) {
      setState(() {
        _emailError = 'Некорректная почта';
      });
      isValid = false;
    } else {
      setState(() {
        _emailError = null;
      });
    }

    return isValid;
  }

  bool _validatePrimaryFieldsTwo() {
    bool isValid = true;
    if (_dateController.text.trim().isEmpty) {
      setState(() {
        _dateError = 'Обязательное поле';
      });
      isValid = false;
    } else {
      setState(() {
        _dateError = null;
      });
    }

    if (_timeController.text.trim().isEmpty) {
      setState(() {
        _timeError = 'Обязательное поле';
      });
      isValid = false;
    } else {
      setState(() {
        _timeError = null;
      });
    }

    return isValid;
  }

  @override
  void initState() {
    super.initState();
    _loadTables(); // Загружаем столы при открытии экрана
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 229, 217, 201),
      drawer: _dialogMenu(context),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderSite(
                isMobile: isMobile,
                onMenuTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24.0 : 120.0,
                  vertical: isMobile ? 25.0 : 100.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Форма бронирования',
                      style: TextStyle(
                        fontSize: isMobile ? 30 : 50,
                        color: Color(0xFF3A2B28),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: isMobile ? 300 : 900,
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 252, 231),
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF3A2B28),
                              width: 3.0,
                            ),
                          ),
                          hintText: "Имя",
                          errorText: _nameError,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: isMobile ? 300 : 900,
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 252, 231),
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF3A2B28),
                              width: 3.0,
                            ),
                          ),
                          hintText: "Телефон",
                          errorText: _phoneError,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: isMobile ? 300 : 900,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 252, 231),
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF3A2B28),
                              width: 3.0,
                            ),
                          ),
                          hintText: "Почта",
                          errorText: _emailError,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(40)),
                    ElevatedButton(
                      onPressed: () {
                        if (_validatePrimaryFields()) {
                          _showDialogOneTwo();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 30),
                        backgroundColor: Color.fromARGB(255, 255, 252, 231),
                        elevation: 5,
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          left: 40,
                          right: 40,
                        ),
                      ),
                      child: Text(
                        'ДАЛЕЕ',
                        style: TextStyle(color: Color(0xFF3A2B28)),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
              FooterScreen(),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialogOneTwo() {
    String? selectedTableId;
    List<String> occupiedTables = List.from(_occupiedTables);
    //List<Map<String, dynamic>> localTables = List.from(tables);
    int step = 0;

    showDialog(
      context: context,
      builder: (dialogContext) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadTables();
        });

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Color.fromARGB(214, 58, 43, 40),
              child: Container(
                height: MediaQuery.of(context).size.width < 900 ? 550 : 700,
                width: MediaQuery.of(context).size.width < 900 ? 600 : 900,
                padding: EdgeInsets.all(20),
                child: step == 0
                    ? _buildStepOne(context, setState, () {
                        final date = _dateController.text.trim();
                        final time = _timeController.text.trim();
                        if (date.isNotEmpty && time.isNotEmpty) {
                          _loadOccupiedTables(date, time).then((_) {
                            // Обновляем копию после загрузки
                            setState(() {
                              occupiedTables = List.from(_occupiedTables);
                              step = 1;
                            });
                          });
                        }
                      })
                    : _buildStepTwo(
                        dialogContext,
                        tables,
                        occupiedTables,
                        selectedTableId,
                        (id) => setState(() => selectedTableId = id),
                        () => _submitBooking(
                          dialogContext: dialogContext,
                          selectedTableId: selectedTableId!,
                          guests:
                              int.tryParse(_guestsController.text.trim()) ?? 1,
                          name: _nameController.text.trim(),
                          phone: _phoneController.text.trim(),
                          email: _emailController.text.trim(),
                          date: _dateController.text.trim(),
                          time: _timeController.text.trim(),
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStepOne(
    BuildContext context,
    StateSetter setState,
    VoidCallback onNext,
  ) {
    return Column(
      children: [
        SizedBox(height: 50),
        Text(
          'Форма брони',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width < 600 ? 40 : 50,
            color: Color.fromARGB(255, 255, 252, 231),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 700,
          child: TextField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 252, 231),
                  width: 3.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A2B28), width: 3.0),
              ),
              hintText: "Дата",
              errorText: _dateError,
              hintStyle: TextStyle(color: Color.fromARGB(255, 255, 252, 231)),
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (picked != null) {
                _dateController.text =
                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                setState(() {
                  _dateError = null;
                });
              }
            },
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 700,
          child: TextField(
            controller: _timeController,
            readOnly: true,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 252, 231),
                  width: 3.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A2B28), width: 3.0),
              ),
              hintText: "Время",
              errorText: _timeError,
              hintStyle: TextStyle(color: Color.fromARGB(255, 255, 252, 231)),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                _timeController.text =
                    "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                setState(() {
                  _timeError = null;
                });
              }
            },
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 700,
          child: TextField(
            controller: _guestsController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 252, 231),
                  width: 3.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A2B28), width: 3.0),
              ),
              hintText: "Количество гостей",
              hintStyle: TextStyle(color: Color.fromARGB(255, 255, 252, 231)),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.width < 600 ? 30 : 60),
        ElevatedButton(
          onPressed: () {
            if (_validatePrimaryFieldsTwo()) {
              onNext();
            }
          },
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 30,
            ),
            backgroundColor: Color.fromARGB(255, 255, 252, 231),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
          child: Text('ДАЛЕЕ', style: TextStyle(color: Color(0xFF3A2B28))),
        ),
      ],
    );
  }

  Widget _buildStepTwo(
    BuildContext dialogContext,
    List<Map<String, dynamic>> tables,
    List<String> occupiedTables,
    String? selectedTableId,
    void Function(String?) onTableSelected,
    VoidCallback onBook,
  ) {
    final size = MediaQuery.of(dialogContext).size;
    final containerWidth = size.width < 600 ? 500 : 600;
    final containerHeight = size.width < 600 ? 250 : 480;

    return Column(
      children: [
        Text(
          'Выбор доступного столика',
          style: TextStyle(
            fontSize: size.width < 600 ? 20 : 40,
            color: Color.fromARGB(255, 255, 252, 231),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: containerWidth.toDouble(),
          height: containerHeight.toDouble(),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/cafe_layout.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ...tables.map((table) {
                final tableId = table['id'];
                if (tableId == null) return Container();
                final idStr = tableId.toString();
                final xPercent =
                    double.tryParse(table['x_percent'].toString()) ?? 0.0;
                final yPercent =
                    double.tryParse(table['y_percent'].toString()) ?? 0.0;
                double x = xPercent * containerWidth;
                double y = yPercent * containerHeight;

                Color color = Colors.purple[700]!;
                if (occupiedTables.contains(idStr)) {
                  color = Colors.red[700]!;
                } else if (selectedTableId == idStr) {
                  color = Colors.green[700]!;
                }

                return Positioned(
                  left: x - 15,
                  top: y - 13,
                  child: GestureDetector(
                    onTap: () {
                      if (!occupiedTables.contains(idStr)) {
                        onTableSelected(idStr);
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          idStr.length > 1 ? idStr.substring(6) : idStr,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: selectedTableId == null ? null : onBook,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 255, 252, 231),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: Text(
            'Забронировать',
            style: TextStyle(color: Color(0xFF3A2B28), fontSize: 23),
          ),
        ),
      ],
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
          ListTile(title: Text('Главная'), onTap: () => Navigator.pop(context)),
          ListTile(title: Text('О нас'), onTap: () => Navigator.pop(context)),
          ListTile(title: Text('Котики'), onTap: () => Navigator.pop(context)),
          ListTile(
            title: Text('Меню'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuPagesScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Контакты'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
