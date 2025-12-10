import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? _selectedTableId;

  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _dateError;
  String? _timeError;
  String? _guestsError;

  Future<void> _loadTables() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tables')
          .get();

      setState(() {
        tables = snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList();
      });
    } catch (e) {
      print('Ошибка загрузки столов: $e');
    }
  }

  Future<void> _loadOccupiedTables(String date, String time) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('date', isEqualTo: date)
          .where('time', isEqualTo: time)
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();

      print('Загружаем занятые столы для даты: $date, времени: $time');
      print('Найдено броней: ${snapshot.size}');
      snapshot.docs.forEach((doc) {
        print('Бронь: tableId=${doc['tableId']}, status=${doc['status']}');
      });

      setState(() {
        _occupiedTables = snapshot.docs
            .map((doc) => doc['tableId'] as String)
            .toList();
      });
    } catch (e) {
      print('Ошибка загрузки занятых столов: $e');
    }
  }

  void _submitBooking() async {
    if (_selectedTableId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Выберите столик')));
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'date': _dateController.text.trim(),
        'time': _timeController.text.trim(),
        'guests': _guestsController.text.trim(),
        'tableId': _selectedTableId!,
        'status': 'pending',
        'crearedAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(DateTime.now().add(Duration(hours: 3))),
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Бронь создана')));
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
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

  // void _showErrorSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

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
                        fontSize: MediaQuery.of(context).size.width < 600
                            ? 30
                            : 50,
                        color: Color(0xFF3A2B28),
                      ),
                    ),

                    //поле для ввода имени
                    Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width < 900
                          ? 300
                          : 900,
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

                    //поле для ввода телефона
                    Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width < 900
                          ? 300
                          : 900,
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

                    //поле для ввода почты
                    Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width < 900
                          ? 300
                          : 900,
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

                    //КНОПКА "ДАЛЕЕ"
                    Padding(padding: EdgeInsets.all(40)),
                    Container(
                      child: ElevatedButton(
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
                        //текст
                        child: Text(
                          'ДАЛЕЕ',
                          style: TextStyle(color: Color(0xFF3A2B28)),
                        ),
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

  //всплывающие окна (2 штуки)
  void _showDialogOneTwo() {
    showDialog(
      context: context,
      builder: (context) {
        int step = 0;
        String? _selectedTableId;

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
                    ? _showDialogOne(() {
                        setState(() {
                          step = 1;
                        });
                      })
                    : _showDialogTwo(() {
                        setState(() {
                          step = 0;
                        });
                      },
                      
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _showDialogOne(VoidCallback onNext) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 50)),
        Text(
          'Форма брони',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width < 600 ? 40 : 50,
            color: Color.fromARGB(255, 255, 252, 231),
          ),
        ),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //поле для ввода даты
              Padding(padding: EdgeInsets.all(20)),
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
                      borderSide: BorderSide(
                        color: Color(0xFF3A2B28),
                        width: 3.0,
                      ),
                    ),
                    hintText: "Дата",
                    errorText: _dateError,
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 252, 231),
                    ),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) {
                      _dateController.text =
                          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    }
                  },
                ),
              ),

              //поле для ввода времени
              Padding(padding: EdgeInsets.all(20)),
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
                      borderSide: BorderSide(
                        color: Color(0xFF3A2B28),
                        width: 3.0,
                      ),
                    ),
                    hintText: "Время",
                    errorText: _timeError,
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 252, 231),
                    ),
                  ),
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      _timeController.text =
                          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                    }
                  },
                ),
              ),

              //поле для ввода кл-ва гостей
              Padding(padding: EdgeInsets.all(20)),
              SizedBox(
                width: 700,
                child: TextField(
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
                    hintText: "Количество гостей",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 252, 231),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width < 600 ? 30 : 60,
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_validatePrimaryFieldsTwo()) {
                      final selectedDate = _dateController.text.trim();
                      final selectedTime = _timeController.text.trim();

                      await _loadOccupiedTables(selectedDate, selectedTime);

                      onNext();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 600
                          ? 20
                          : 30,
                    ),
                    backgroundColor: Color.fromARGB(255, 255, 252, 231),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text(
                    'ДАЛЕЕ',
                    style: TextStyle(color: Color(0xFF3A2B28)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //2 диалоговое окно для выбора доступного столика
  Widget _showDialogTwo(VoidCallback onBack) {
    return Center(
      child: Column(
        children: [
          Text(
            'Выбор доступного столика',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 40,
              color: Color.fromARGB(255, 255, 252, 231),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          SizedBox(
            width: MediaQuery.of(context).size.width < 600 ? 500 : 600,
            height: MediaQuery.of(context).size.width < 600 ? 250 : 480,
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
                ..._buildTableButtons(context),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width < 600 ? 60 : 10,
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: _submitBooking,
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 30,
                ),
                backgroundColor: Color.fromARGB(255, 255, 252, 231),
                elevation: 5,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                'Забронировать',
                style: TextStyle(color: Color(0xFF3A2B28), fontSize: 23),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTableButtons(BuildContext content) {
    final size = MediaQuery.of(content).size;
    final containerWidth = size.width < 600 ? 500 : 500;
    final containerHeight = size.width < 600 ? 250 : 480;

    return tables.map((table) {
      final tableId = table['id'];
      print('Стол: tableId = $tableId (тип: ${tableId.runtimeType})');

      if (tableId == null) {
        print('Пропущен стол без id: $table');
        return Container();
      }
      final idStr = tableId.toString();

      final xPercent = (table['x_percent'] as num?)?.toDouble() ?? 0.0;
      final yPercent = (table['y_percent'] as num?)?.toDouble() ?? 0.0;
      double x = xPercent * containerWidth;
      double y = yPercent * containerHeight;

      Color color = Colors.purple[700]!;

      if (_occupiedTables.contains(table['id'])) {
        color = Colors.red[700]!; // занят
      } else if (_selectedTableId == table['id']) {
        color = Colors.green[700]!; // выбран
      }
      return Positioned(
        left: x - 15,
        top: y - 13,
        child: GestureDetector(
          onTap: () {
            if (!_occupiedTables.contains(idStr)) {
              print('Выбран стол: $idStr');
              setState(() {
                _selectedTableId = idStr;
              });
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
    }).toList();
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
