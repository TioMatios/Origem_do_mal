import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'imagem_modelo.dart'; // Precisamos deste ficheiro

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ImagemModelo> imagens = [];
  // 1. Adicionamos uma variável para controlar o estado de carregamento
  bool _estaCarregando = true;

  @override
  void initState() {
    super.initState();
    _carregarImagens();
  }

  Future<void> _carregarImagens() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('lista_imagens');
    List<ImagemModelo> imagensSalvas = [];

    if (jsonString != null) {
      try {
        final List<dynamic> listaDecodificada = json.decode(jsonString);
        imagensSalvas = listaDecodificada
            .map((item) => ImagemModelo.fromMap(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        await prefs.remove('lista_imagens');
      }
    }

    if (imagensSalvas.isEmpty) {
      imagensSalvas = List.generate(
        14,
            (index) => ImagemModelo(
          asset: "images/imagem${index + 1}.jpeg",
          descricao: "Imagem ${index + 1}",
        ),
      );
    }

    if (mounted) {
      setState(() {
        imagens = imagensSalvas;
        // 2. Quando as imagens estiverem prontas, dizemos que o carregamento terminou
        _estaCarregando = false;
      });
    }
  }

  Future<void> _salvarImagens() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString =
    json.encode(imagens.map((img) => img.toMap()).toList());
    await prefs.setString('lista_imagens', jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Search', style: TextStyle(color: Colors.white)),
      ),
      // 3. Verificamos se está a carregar antes de desenhar a grelha
      body: _estaCarregando
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: imagens.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5),
          itemBuilder: (context, index) {
            final img = imagens[index];

            return GestureDetector(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    img.asset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, color: Colors.red);
                    },
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          img.favorita = !img.favorita;
                        });
                        _salvarImagens();
                      },
                      child: Icon(
                        img.favorita
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                        img.favorita ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

