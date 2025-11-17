import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final List<String> imagensDaGaleria = List.generate(
    18, // <- ALTERADO DE 14 PARA 18
        (index) => "images/imagem${index + 1}.jpeg",
  );

  late String imagemSelecionada;
  int abaInferiorSelecionada = 0;

  @override
  void initState() {
    super.initState();
    if (imagensDaGaleria.isNotEmpty) {
      imagemSelecionada = imagensDaGaleria.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String previewImage =
    imagensDaGaleria.contains(imagemSelecionada) ? imagemSelecionada : 'images/logo.png';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
          onPressed: () {
            // ----- CORREÇÃO 1: Adicionado pop para fechar a tela -----
            Navigator.of(context).pop();
            // --------------------------------------------------------
          },
        ),
        title: const Text(
          'Nova publicação',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),

        // ----- CORREÇÃO 2: Evita que o título sobreponha o botão "Avançar" -----
        // (Este era o seu primeiro erro da print)
        centerTitle: false,
        // ---------------------------------------------------------------------

        actions: [
          TextButton(
            onPressed: () {
              // ----- CORREÇÃO 3: Adicionado pop para o botão "Avançar" -----
              // No futuro, isso navegaria para a próxima tela
              Navigator.of(context).pop();
              // -------------------------------------------------------------
            },
            child: const Text(
              'Avançar',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: Colors.grey[900],
              child: Image.asset(
                previewImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recentes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.copy, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Selecionar vários',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: imagensDaGaleria.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                final imgAsset = imagensDaGaleria[index];
                final bool isSelected = (imgAsset == imagemSelecionada);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      imagemSelecionada = imgAsset;
                    });
                  },
                  child: Opacity(
                    opacity: isSelected ? 1.0 : 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2.5)
                            : null,
                      ),
                      child: Image.asset(
                        imgAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.grey[800]);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomTab('PUBLICAÇÃO', 0),
            _buildBottomTab('STORY', 1),
            _buildBottomTab('REEL', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTab(String titulo, int index) {
    final bool isSelected = (abaInferiorSelecionada == index);
    return GestureDetector(
      onTap: () {
        setState(() {
          abaInferiorSelecionada = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: isSelected
            ? BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(20)
        )
            : null,
        child: Text(
          titulo,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}