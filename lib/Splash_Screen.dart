import 'package:flutter/material.dart';
import 'dart:async'; // Para o temporizador
import 'main_page.dart'; // Para onde ele vai navegar

// ESTA É A CLASSE QUE O MAIN.DART ESTÁ PROCURANDO
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Espera 3 segundos e vai para a MainPage
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Apenas um fundo preto com um indicador de carregamento
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}