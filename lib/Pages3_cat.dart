import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cafe/Pages_1.dart';
import 'widgets/SiteHeader.dart';
import 'Pages4_menu.dart';
import 'package:http/http.dart' as http;
import 'widgets/SiteFooter.dart';

const double KHeaderHeight = 80.0;

class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  State<CatScreen> createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> cats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCatsFromFirestore();
  }

  Future<void> _loadCatsFromFirestore() async {
    try {
      //заменить URL
      final response = await http.get(Uri.parse('http://'));
      if (response.statusCode == 200) {
        final catsJson = jsonDecode(response.body) as List;
        setState(() {
          cats = catsJson.map((item) => item as Map<String, dynamic>).toList();
          isLoading = false;
        });

        for (var cat in cats) {
          print('Загружен кот: ${cat['name']} - ${cat['imageUrl']}');
        }
      } else {
          throw Exception('Сервер вернул статус: ${response.statusCode}');
        }

    } catch (e) {
      print('Ошибка загрузки котов: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось загрузить котов')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
    
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _dialogMenu(context),
        backgroundColor: Color.fromARGB(255, 229, 217, 201),
        body: Container(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = MediaQuery.of(context).size.height;
              final headerHeight = KHeaderHeight; // 80.0
              // Оценим высоту футера (~200 px на мобиле, ~120 на десктопе)
              final footerHeight = constraints.maxWidth < 600 ? 200.0 : 120.0;

              final minContentHeight =
                  screenHeight - headerHeight - footerHeight;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Шапка
                    HeaderSite(
                      isMobile: constraints.maxWidth < 600,
                      onMenuTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),

                    // Основной контент с min-height
                    SizedBox(
                      height: minContentHeight > 0 ? minContentHeight : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth < 600
                                  ? 24.0
                                  : 120.0,
                              vertical: constraints.maxWidth < 600
                                  ? 24.0
                                  : 120.0,
                            ),
                            child: isLoading
                                ? Center(child: CircularProgressIndicator())
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Наши котики',
                                        style: TextStyle(
                                          fontSize: constraints.maxWidth < 600
                                              ? 20
                                              : 45,
                                          color: Color(0xFF3A2B28),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      // Сетка котиков
                                      LayoutBuilder(
                                        builder: (context, constraints2) {
                                          final screenWidth =
                                              constraints2.maxWidth;
                                          final crossAxisCount =
                                              screenWidth < 600 ? 2 : 6;
                                          final itemSpacing = screenWidth < 600
                                              ? 20.0
                                              : 30.0;
                                          final itemSize =
                                              (screenWidth -
                                                  (crossAxisCount - 1) *
                                                      itemSpacing) /
                                              crossAxisCount;

                                          return GridView.builder(
                                            itemCount: cats.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      crossAxisCount,
                                                  crossAxisSpacing: itemSpacing,
                                                  mainAxisSpacing:
                                                      itemSpacing * 1.2,
                                                  mainAxisExtent: itemSize + 60,
                                                ),
                                            itemBuilder: (context, index) {
                                              final cat = cats[index];
                                              return GestureDetector(
                                                onTap: () => _showCatDetails(
                                                  context,
                                                  cat,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: itemSize,
                                                      height: itemSize,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.85),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.2,
                                                                ),
                                                            blurRadius: 15,
                                                            spreadRadius: 2,
                                                          ),
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                        child: Image.asset(
                                                          cat['imageUrl'],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      cat['name'],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                          0xFF3A2B28,
                                                        ),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),

                    // ✅ Футер — всегда после контента
                    FooterScreen(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCatDetails(BuildContext context, Map<String, dynamic> cat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Картинка кота
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    cat['imageUrl'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                // Имя
                Text(
                  cat['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A2B28),
                  ),
                ),
                const SizedBox(height: 8),
                // Пол
                Text(
                  'Пол: ${cat['gender']}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                // Описание
                Text(
                  cat['description'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 20),
                // Кнопка "Закрыть"
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3A2B28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Закрыть',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          ListTile(
            title: Text('Главная'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PagesScreen()),
              );
            },
          ),
          ListTile(title: Text('О нас'), onTap: () => Navigator.pop(context)),

          ListTile(
            title: Text('Котики'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CatScreen()),
              );
            },
          ),
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
