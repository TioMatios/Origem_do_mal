import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      // Navega para o MainPage em vez de HomePage/InstagramPostsPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 3),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CORREÇÃO: Voltamos a usar o Image.asset com o seu logótipo
              Image.asset(
                'images/logo.png',
                width: 160, // Definimos um tamanho para a imagem
                height: 160,
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 1600.ms)
                  .slide(begin: const Offset(0, 0.10), duration: 800.ms)
                  .scale(begin: const Offset(0, 0.10), duration: 800.ms)
                  .then(delay: 200.ms),
              const SizedBox(height: 20),
              Text(
                'Instagram',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 1600.ms),
            ],
          ),
        ),
      ),
    );
  }
}

