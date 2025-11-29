import 'package:flutter/material.dart';
import 'package:flutter_cafe/widgets/SiteHeader.dart';
import 'Pages_1.dart';
import 'Pages3_cat.dart';
import 'Pages2_bron.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const double KHeaderHeight = 80.0;

class MenuPagesScreen extends StatefulWidget {
  const MenuPagesScreen({super.key});

  @override
  State<MenuPagesScreen> createState() => _MenuPagesScreenState();
}

class _MenuPagesScreenState extends State<MenuPagesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> menu = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenuFromFirestore();
  }

  Future<void> _loadMenuFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('menu')
          .get();

      setState(() {
        menu = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'name': (data['name'] as String?) ?? 'Без названия',
            'price': (data['price'] as String?) ?? 'Цена не указана',
            'imagesUrl':
                (data['imagesUrl'] as String?) ??
                'assets/images/placeholder.png',
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки меню: $e');
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
              right: 0,
              left: 0,
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
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Блюда дня',
                            style: TextStyle(
                              fontSize: isMobile ? 40 : 50,
                              color: Color(0xFF3A2B28),
                            ),
                          ),
                          const SizedBox(height: 13),
                          Text('Какие блюда наиболее популярны сегодня', style: TextStyle(fontSize: isMobile ? 16 : 20),),
                          const SizedBox(height: 40),

                          if (isLoading)
                            CircularProgressIndicator()
                          else if (menu.isEmpty)
                            Text(
                              'Пока нет блюд в меню',
                              style: TextStyle(color: Colors.grey),
                            )
                          else
                            GridView.builder(
                              padding: EdgeInsets.only(
                                left: isMobile ? 50 : 200,
                                right: isMobile ? 50 : 200,
                                top: isMobile ? 20 : 10,
                              ),
                              itemCount: menu.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isMobile ? 1 : 3,
                                    crossAxisSpacing: isMobile ? 80 : 100,
                                    mainAxisSpacing: isMobile ? 50 : 20,
                                    mainAxisExtent: isMobile
                                        ? 400
                                        : 400, // Высота карточки
                                  ),
                              itemBuilder: (context, index) {
                                final item = menu[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color(
                                      0xFF3A2B28,
                                    ), // 🟤 Коричневый фон, как на картинке
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Изображение
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                        child: Image.asset(
                                          item['imagesUrl'],
                                          height: 280,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Название
                                            Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    item['name'],
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(
                                                                context,
                                                              ).size.width <
                                                              600
                                                          ? 14
                                                          : 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  // Цена
                                                  Text(
                                                    item['price'],
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          Padding(
                            padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width > 600 ? 40 : 20,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BronScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                    ? 30
                                    : 25,
                              ),

                              backgroundColor: Color.fromARGB(
                                255,
                                255,
                                252,
                                231,
                              ),
                              elevation: 5,
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width > 600
                                    ? 25
                                    : 15,
                                vertical:
                                    MediaQuery.of(context).size.width > 600
                                    ? 20
                                    : 15,
                              ),
                            ),
                            child: Text(
                              'ЗАБРОНИРОВАТЬ',
                              style: TextStyle(
                                color: Color(0xFF3A2B28),
                                fontSize: isMobile ? 18 : 25
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                        ],
                      ),
                      //кнопка
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
          ListTile(title: Text('Меню'), onTap: () => Navigator.pop(context)),
          ListTile(
            title: Text('Контакты'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
