import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. O Modelo de Dados foi atualizado
class _ReelModel {
  final String imagePath;
  final String username;
  final String caption;
  final String audioName;
  bool isLiked; // Adicionado para rastrear a curtida

  _ReelModel({
    required this.imagePath,
    required this.username,
    required this.caption,
    required this.audioName,
    this.isLiked = false, // Começa como 'não curtido'
  });
}

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  // Lista de "Reels" usando as imagens locais
  // *** ALTERADO DE 14 PARA 18 ***
  final List<_ReelModel> reels = List.generate(
    18,
        (index) => _ReelModel(
      imagePath: "images/imagem${index + 1}.jpeg",
      username: "usuario_${index + 1}",
      caption: "Mantego ${index + 1}! #flutter #clone",
      audioName: "Áudio Original - usuario_${index + 1}",
    ),
  );

  // Chave para salvar no SharedPreferences
  final String _likesKey = 'reels_likes_list';

  @override
  void initState() {
    super.initState();
    // 2. Carrega as curtidas salvas quando a tela iniciar
    _loadLikes();
  }

  // Função para CARREGAR as curtidas salvas
  Future<void> _loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    // Pega a lista de 'imagePaths' que foram curtidas
    final List<String> likedImages = prefs.getStringList(_likesKey) ?? [];

    if (likedImages.isNotEmpty) {
      // Atualiza o modelo de dados
      setState(() {
        for (var reel in reels) {
          if (likedImages.contains(reel.imagePath)) {
            reel.isLiked = true;
          }
        }
      });
    }
  }

  // Função para SALVAR as curtidas
  Future<void> _saveLikes() async {
    final prefs = await SharedPreferences.getInstance();
    // Cria uma lista apenas com os 'imagePaths' dos Reels curtidos
    final List<String> likedImages = reels
        .where((reel) => reel.isLiked)
        .map((reel) => reel.imagePath)
        .toList();

    // Salva a lista no dispositivo
    await prefs.setStringList(_likesKey, likedImages);
  }

  // 3. Função para alternar a curtida (chamada pelo widget filho)
  void _toggleLike(int index) {
    setState(() {
      reels[index].isLiked = !reels[index].isLiked;
    });
    // Salva o novo estado de curtidas
    _saveLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          return ReelVideoWidget(
            reel: reels[index],
            // 4. Passa a função de 'curtir' para o widget filho
            onLikePressed: () => _toggleLike(index),
          );
        },
      ),
    );
  }
}

// Widget para exibir um único Reel (imagem + overlays)
class ReelVideoWidget extends StatelessWidget {
  final _ReelModel reel;
  // 5. Recebe a função de callback
  final VoidCallback onLikePressed;

  const ReelVideoWidget({
    super.key,
    required this.reel,
    required this.onLikePressed,
  });

  final TextStyle textStyle = const TextStyle(
    color: Colors.white,
    shadows: [
      Shadow(blurRadius: 8.0, color: Colors.black54),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          reel.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: const Center(
                child: Icon(Icons.error_outline, color: Colors.white, size: 40),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _buildInfoPanel(),
                  ),
                  _buildActionsPanel(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              reel.username,
              style: textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                side: const BorderSide(color: Colors.white, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Seguir', style: textStyle.copyWith(fontSize: 14)),
            )
          ],
        ),
        const SizedBox(height: 8),
        Text(reel.caption, style: textStyle, maxLines: 2, overflow: TextOverflow.ellipsis,),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.music_note, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(reel.audioName, style: textStyle.copyWith(fontSize: 13)),
          ],
        ),
      ],
    );
  }

  // Painel de Ações (Curtir, Comentar, Enviar, Mais)
  Widget _buildActionsPanel() {
    return Column(
      children: [
        // 6. Botão de Curtir agora é funcional
        GestureDetector(
          onTap: onLikePressed, // Chama a função de callback
          child: _buildActionButton(
            // Altera o ícone e a cor com base no estado 'isLiked'
            icon: reel.isLiked ? Icons.favorite : Icons.favorite_border,
            label: "1.2M", // Você pode querer atualizar isso também
            iconColor: reel.isLiked ? Colors.red : Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildActionButton(icon: Icons.comment, label: "978"),
        const SizedBox(height: 16),
        _buildActionButton(icon: Icons.send, label: "22K"),
        const SizedBox(height: 16),
        const Icon(Icons.more_vert, color: Colors.white, size: 30),
        const SizedBox(height: 16),
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[800],
          ),
          child: const Icon(Icons.music_note, color: Colors.white, size: 18),
        )
      ],
    );
  }

  // 7. Widget auxiliar atualizado para aceitar uma cor de ícone
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color iconColor = Colors.white, // Cor padrão é branca
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 30), // Usa a cor passada
        const SizedBox(height: 4),
        Text(
          label,
          style: textStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}