import 'package:flutter/material.dart';
import 'package:flutter_cafe/Pages_1.dart';
import 'SiteHeader.dart';
import 'Pages4_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      final snapshot = await FirebaseFirestore.instance
          .collection('cats')
          .get();

      setState(() {
        cats = snapshot.docs.map((doc) {
          final data = doc.data();
          print('Загружен кот: ${data['name']} - ${data['imageUrl']}');
          return {
            'name': data['name'] as String,
            'description': data['description'] as String,
            'gender': data['gender'] as String,
            'imageUrl': data['imageUrl'] as String,
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки котов: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/фон3.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _dialogMenu(context),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: HeaderSite(
                isMobile: isMobile,
                onMenuTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),

            Builder(
              builder: (context) {
                final isMobile = MediaQuery.of(context).size.width < 600;
                final horizontalPadding = isMobile ? 24.0 : 120.0;

                return Padding(
                  padding: EdgeInsets.only(
                    top: KHeaderHeight + 80,
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: 20,
                  ),

                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Наши котики',
                                style: TextStyle(
                                  fontSize: isMobile ? 20 : 45,
                                  color: Color(0xFF3A2B28),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ), // вертикальный отступ (не width!)
                              // Сетка котиков
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final screenWidth = constraints.maxWidth;
                                  final crossAxisCount = screenWidth < 600
                                      ? 1
                                      : 6;
                                  final itemSpacing = isMobile ? 20.0 : 30.0;
                                  final itemSize =
                                      (screenWidth -
                                          (crossAxisCount - 1) * itemSpacing) /
                                      crossAxisCount;

                                  return GridView.builder(
                                    itemCount: cats.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          crossAxisSpacing: itemSpacing,
                                          mainAxisSpacing: itemSpacing * 1.2,
                                          mainAxisExtent: itemSize + 60,
                                        ),
                                    itemBuilder: (context, index) {
                                      final cat = cats[index];
                                      return GestureDetector(
                                        onTap: () {
                                          _showCatDetails(context, cat);
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: itemSize,
                                              height: itemSize,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                  0,
                                                  255,
                                                  255,
                                                  255,
                                                ).withOpacity(0.85),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 15,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                child: Image.asset(
                                                  cat['imageUrl'],
                                                  height: 300,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              cat['name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF3A2B28),
                                              ),
                                              textAlign: TextAlign.center,
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
                );
              },
            ),
          ],
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
