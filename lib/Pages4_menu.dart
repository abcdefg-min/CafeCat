import 'package:flutter/material.dart';
import 'package:flutter_cafe/SiteHeader.dart';
import 'Pages_1.dart';
import 'Pages3_cat.dart';
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
            'name': (data['name'] ?? '').toString(),
            'price': (data['price'] ?? '').toString(),
            'imagesUrl': (data['imagesUrl'] ?? 'assets/images/placeholder.png')
                .toString(),
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

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Блюда дня',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 600
                          ? 30
                          : 50,
                      color: Color(0xFF3A2B28),
                    ),
                  ),

                  //добавить блоки, в которых будут находиться меню
                  const SizedBox(height: 40),

                  if (isLoading)
                    CircularProgressIndicator()
                  else if (menu.isEmpty)
                    Text('Пока нет блюд в меню')
                  else
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        itemCount: menu.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 1 : 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 250,
                        ),
                        itemBuilder: (context, index) {
                          final item = menu[index];

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    item['imagesUrl'],
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF3A2B28),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(item['price']),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
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
