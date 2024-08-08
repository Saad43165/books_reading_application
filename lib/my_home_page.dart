import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'package:untitled/categorylistscreen.dart';
import 'app_colors.dart' as AppColors;
import 'my_tabs.dart';
import 'booksdetailspage.dart';
import 'category_screen.dart'; // Import CategoryScreen
import 'my_books_screen.dart'; // Import MyBooksScreen
import 'book_search_delegate.dart'; // Import BookSearchDelegate
import 'settings_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required void Function(bool isDarkMode) toggleDarkMode});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<dynamic> popularBooks = [];
  List<dynamic> books = [];
  List<dynamic> trendingBooks = [];
  late TabController _tabController;
  late ScrollController _scrollController;
  TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isDrawerOpen = false;
  late AnimationController _drawerAnimationController;
  late Animation<Offset> _drawerAnimation;
  late Animation<double> _backgroundScaleAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    ReadData();

    _drawerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _drawerAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    ));

    _backgroundScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _drawerAnimationController.dispose();
    super.dispose();
  }

  ReadData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/popularBooks.json")
        .then((s) {
      setState(() {
        final data = json.decode(s);
        popularBooks = data['books'];
      });
    });
    await DefaultAssetBundle.of(context)
        .loadString("json/books.json")
        .then((s) {
      setState(() {
        final data = json.decode(s);
        books = data['books'];
      });
    });
    await DefaultAssetBundle.of(context)
        .loadString("json/trendingbooks.json")
        .then((s) {
      setState(() {
        final data = json.decode(s);
        trendingBooks = data['books'];
      });
    });
  }

  void _toggleDrawer() {
    setState(() {
      if (_isDrawerOpen) {
        _drawerAnimationController.reverse();
      } else {
        _drawerAnimationController.forward();
      }
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('My Library'),
        backgroundColor: AppColors.menu1Color,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(books),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications are under development')),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Image.asset(
            'img/menu.png', // Replace with your image asset
            width: 24, // Adjust the width as needed
            height: 24, // Adjust the height as needed
          ),
          onPressed: _toggleDrawer,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 18),
                    child: const Text(
                      'Popular Books',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: -20,
                      right: 0,
                      child: SizedBox(
                        height: 180,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.8),
                          itemCount: popularBooks.length,
                          itemBuilder: (_, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookDetailsPage(book: popularBooks[i]),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 180,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: AssetImage(popularBooks[i]['image']),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (BuildContext context, bool isScroll) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: AppColors.silverBackground,
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(50),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: TabBar(
                              indicatorPadding: const EdgeInsets.all(0),
                              indicatorSize: TabBarIndicatorSize.label,
                              labelPadding: const EdgeInsets.only(right: 10),
                              controller: _tabController,
                              isScrollable: true,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 7,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              tabs: [
                                AppTabs(
                                    color: AppColors.menu1Color, text: "New"),
                                AppTabs(
                                    color: AppColors.menu2Color,
                                    text: "Popular"),
                                AppTabs(
                                    color: AppColors.menu3Color,
                                    text: "Trending"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (_, i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailsPage(book: books[i]),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 7,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Add border radius
                                    child: Image.asset(
                                      books[i]['image'],
                                      width: 100,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          books[i]['title'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Avenir',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          books[i]['author'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Avenir',
                                              color: AppColors.subTitleText),
                                        ),
                                        Text(
                                          'Rating: ${books[i]['rating']}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.starColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: popularBooks.length,
                        itemBuilder: (_, i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailsPage(book: popularBooks[i]),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 7,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Add border radius
                                    child: Image.asset(
                                      popularBooks[i]['image'],
                                      width: 100,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          popularBooks[i]['title'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Avenir',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          popularBooks[i]['author'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Avenir',
                                              color: AppColors.subTitleText),
                                        ),
                                        Text(
                                          'Rating: ${popularBooks[i]['rating']}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.starColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (_, i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailsPage(book: books[i]),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 7,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Add border radius
                                    child: Image.asset(
                                      books[i]['image'],
                                      width: 100,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          books[i]['title'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Avenir',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          books[i]['author'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Avenir',
                                              color: AppColors.subTitleText),
                                        ),
                                        Text(
                                          'Rating: ${books[i]['rating']}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.starColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // Add similar widgets for popular and trending sections
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isDrawerOpen)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10.0,
                  sigmaY: 10.0,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          SlideTransition(
            position: _drawerAnimation,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: AppColors.menu1Color,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          'img/my-pic.jpg',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    accountName: Text('Saad Ikram'),
                    accountEmail: Text('saad43165@example.com'),
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text('Categories'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text('My Books'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyBooksScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen(isDarkMode: true, toggleDarkMode: (bool isDarkMode) {  },)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      // Add logout functionality here
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
