import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Importação necessária

// URL da API de posts do DummyJSON
const String dummyJsonPostsUrl = 'https://dummyjson.com/posts';

class InstagramPostsPage extends StatefulWidget {
  const InstagramPostsPage({super.key});

  @override
  State<InstagramPostsPage> createState() => _InstagramPostsPageState();
}

class _InstagramPostsPageState extends State<InstagramPostsPage> {
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchDummyJsonPosts();
  }

  /// 🌐 Método para buscar dados da API DummyJSON
  Future<List<Post>> fetchDummyJsonPosts() async {
    final response = await http.get(Uri.parse(dummyJsonPostsUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> postsJson = data['posts'] as List<dynamic>? ?? [];
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar os posts do DummyJSON. Status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Instagram',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.send_outlined, color: Colors.white, size: 28),
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '❌ Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final postList = snapshot.data!;
          return ListView.builder(
            itemCount: postList.length,
            itemBuilder: (context, index) {
              final post = postList[index];
              // Adicionamos a 'key' para ajudar a identificar o widget após o recarregamento
              return PostWidget(key: ValueKey(post.id), post: post);
            },
          );
        },
      ),
    );
  }
}

// --- Definição da Classe Post (Inalterada) ---
class Post {
  final int id;
  final String username;
  final String userProfilePic;
  final String postImage;
  final String caption;
  final int likes;

  Post({
    required this.id,
    required this.username,
    required this.userProfilePic,
    required this.postImage,
    required this.caption,
    required this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final int postId = (json['id'] as num?)?.toInt() ?? 0;
    final int userId = (json['userId'] as num?)?.toInt() ?? 0;
    final Map<String, dynamic> reactions = json['reactions'] as Map<String, dynamic>? ?? {};
    final int likesCount = (reactions['likes'] as num?)?.toInt() ?? 0;
    final String body = json['body'] as String? ?? 'Nenhuma legenda fornecida.';

    return Post(
      id: postId,
      caption: body,
      username: 'user_${userId}',
      likes: likesCount,
      userProfilePic: "https://i.pravatar.cc/150?img=${userId + 10}",
      postImage: "https://picsum.photos/seed/post$postId/400/400",
    );
  }
}

// --- PostWidget Transformado em StatefulWidget ---
class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late bool _isLiked;
  late int _displayLikes; // Para gerenciar o aumento/diminuição das curtidas

  @override
  void initState() {
    super.initState();
    _displayLikes = widget.post.likes;
    _isLiked = false;
    _loadLikeStatus(); // Carrega o estado salvo
  }

  // 💾 Carrega o estado 'isLiked' do SharedPreferences
  void _loadLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // A chave é única por post. Ex: 'like_status_1', 'like_status_2', etc.
    final bool? liked = prefs.getBool('like_status_${widget.post.id}');

    if (mounted) {
      setState(() {
        // Se já foi salvo como true, usa true. Caso contrário, usa false.
        _isLiked = liked ?? false;
        // Ajusta a contagem inicial se já estiver curtido
        if (_isLiked) {
          _displayLikes = widget.post.likes + 1;
        } else {
          _displayLikes = widget.post.likes;
        }
      });
    }
  }

  // ❤️ Alterna o estado de curtida e salva no SharedPreferences
  void _toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    final bool newState = !_isLiked;

    // 1. Atualiza o estado local e a contagem de likes
    setState(() {
      _isLiked = newState;
      if (_isLiked) {
        _displayLikes++;
      } else {
        _displayLikes--;
      }
    });

    // 2. Salva o novo estado no armazenamento local
    await prefs.setBool('like_status_${widget.post.id}', newState);
  }

  @override
  Widget build(BuildContext context) {
    final likeIcon = _isLiked ? Icons.favorite : Icons.favorite_border;
    final iconColor = _isLiked ? Colors.red : Colors.white;

    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (inalterado)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.post.userProfilePic),
                  backgroundColor: Colors.grey[900],
                ),
                const SizedBox(width: 10),
                Text(
                  widget.post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.more_vert, color: Colors.white, size: 24),
              ],
            ),
          ),

          // Imagem da postagem com placeholder (inalterado)
          GestureDetector(
            onDoubleTap: _toggleLike, // Curte ao dar double-tap na imagem
            child: Image.network(
              widget.post.postImage,
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 400,
                  color: Colors.grey[900],
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                height: 400,
                color: Colors.red[900],
                child: const Center(
                  child: Text('Erro ao carregar imagem', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),

          // Ações (Like, Comment, Share)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 8, bottom: 4),
            child: Row(
              children: [
                // 💖 Botão de Curtir
                IconButton(
                  icon: Icon(likeIcon, color: iconColor, size: 28),
                  onPressed: _toggleLike, // Curte ao clicar no botão
                ),
                const SizedBox(width: 16),
                const Icon(Icons.comment_outlined, color: Colors.white, size: 28),
                const SizedBox(width: 16),
                const Icon(Icons.send_outlined, color: Colors.white, size: 28),
                const Spacer(),
                const Icon(Icons.bookmark_border, color: Colors.white, size: 28),
              ],
            ),
          ),

          // Likes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              // Exibe a contagem de likes dinâmica
              '${_displayLikes} curtidas',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Legenda (inalterado)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: widget.post.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: widget.post.caption),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}