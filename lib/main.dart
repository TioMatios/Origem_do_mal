import 'package:flutter/material.dart';
// 1. CORREÇÃO: A importação agora está minúscula,
//    combinando com o novo nome do arquivo.
import 'Splash_Screen.dart';

// A função main precisa ser 'async'.
Future<void> main() async {
  // Esta linha é ESSENCIAL para que o SharedPreferences funcione.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      // 2. Esta linha estava correta, o problema era só a importação.
      home: const SplashScreen(),
    );
  }
}