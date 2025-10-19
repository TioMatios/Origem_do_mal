import 'package:flutter/material.dart';
import 'home_page.dart';    // InstagramPostsPage
import 'search_page.dart';  // SearchPage
import 'account_page.dart'; // AccountPage funcional

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int indiceAtual = 0;

  final List<Widget> paginas = [
    const InstagramPostsPage(), // Home
    const SearchPage(),         // Search
    const Center(
      child: Text('Create', style: TextStyle(color: Colors.white, fontSize: 24)),
    ),
    const Center(
      child: Text('Reels', style: TextStyle(color: Colors.white, fontSize: 24)),
    ),
    const AccountPage(),        // Account funcional
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: indiceAtual,
        children: paginas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indiceAtual,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (indice) {
          setState(() {
            indiceAtual = indice;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_outlined),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
