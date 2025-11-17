import 'package:flutter/material.dart';
import 'home_page.dart';       // 0. Sua tela de posts (Home)
import 'search_page.dart';    // 1. Sua tela de pesquisa
import 'create_post_page.dart'; // 2. Sua tela de criar post
import 'reels_page.dart';     // 3. Sua tela de Reels
import 'account_page.dart';   // 4. Sua tela de Perfil

// Vamos usar o nome 'MainPage' (como estava no seu erro original)
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Começa no índice 0 (HomePage)

  // Lista de todas as suas telas
  static const List<Widget> _widgetOptions = <Widget>[
    InstagramPostsPage(), // Índice 0
    SearchPage(),         // Índice 1
    CreatePostPage(),     // Índice 2
    ReelsPage(),          // Índice 3
    AccountPage(),        // Índice 4
  ];

  void _onItemTapped(int index) {
    // O 'Criar Post' (índice 2) não deve mudar a tela principal,
    // mas sim abrir uma nova tela por cima
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CreatePostPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Exibe a tela que foi selecionada na lista
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // A barra de navegação
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Pesquisa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Criar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed, // Mantém o fundo preto
        showSelectedLabels: false, // Esconde os rótulos
        showUnselectedLabels: false, // Esconde os rótulos
        onTap: _onItemTapped,
      ),
    );
  }
}