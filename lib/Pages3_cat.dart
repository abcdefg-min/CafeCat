import 'package:flutter/material.dart';
import 'package:flutter_cafe/Pages_1.dart';
import 'SiteHeader.dart';


const double KHeaderHeight = 80.0;
class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  State<CatScreen> createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                final horizontalPadding = isMobile ? 24.0 : 60.0;

                final catNames = [
                  'Дин',
                  'Кас',
                  'Сэм',
                  'Дин',
                  'Кас',
                  'Сэм',
                  'Дин',
                  'Кас',
                  'Сэм',
                ];

                final catImages = [
                  'assets/images/cat/DIN.png',
                  'assets/images/cat/KAS.png',
                  'assets/images/cat/SAM.png',
                  'assets/images/cat/DIN.png',
                  'assets/images/cat/KAS.png',
                  'assets/images/cat/SAM.png',
                  'assets/images/cat/DIN.png',
                  'assets/images/cat/KAS.png',
                  'assets/images/cat/SAM.png',
                ];

                return Padding(
                  padding: EdgeInsets.only(
                    top: KHeaderHeight + 80,
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: 20,
                  ),

                  child: SingleChildScrollView(
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
                            final crossAxisCount = screenWidth < 600 ? 1 : 6;
                            final itemSpacing = isMobile ? 20.0 : 30.0;
                            final itemSize =
                                (screenWidth -
                                    (crossAxisCount - 1) * itemSpacing) /
                                crossAxisCount;

                            return GridView.builder(
                              itemCount: catNames.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: itemSpacing,
                                    mainAxisSpacing: itemSpacing * 1.2,
                                    mainAxisExtent: itemSize + 60,
                                  ),
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: itemSize,
                                      height: itemSize,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.85),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 6,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.asset(
                                          catImages[index],
                                          // width: screenWidth < 600 ? 150 : 200,
                                          // height: screenWidth < 600 ? 150 : 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      catNames[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3A2B28),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
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
