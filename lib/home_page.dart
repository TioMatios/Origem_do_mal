import 'package:flutter/material.dart';

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
    posts = fetchFakePosts();
  }

  Future<List<Post>> fetchFakePosts() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay API

    return List.generate(
      10,
          (i) => Post(
        username: "user_$i",
        userProfilePic: "https://i.pravatar.cc/150?img=${i + 10}", // avatar fake
        postImage: "https://picsum.photos/seed/post$i/400/400", // imagem fake
        caption: "Legenda da foto $i. Curta e compartilhe!",
        likes: 1000 + i * 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Instagram - Postagens'),
        centerTitle: true,
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
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final postList = snapshot.data!;
          return ListView.builder(
            itemCount: postList.length,
            itemBuilder: (context, index) {
              final post = postList[index];
              return PostWidget(post: post);
            },
          );
        },
      ),
    );
  }
}

class Post {
  final String username;
  final String userProfilePic;
  final String postImage;
  final String caption;
  final int likes;

  Post({
    required this.username,
    required this.userProfilePic,
    required this.postImage,
    required this.caption,
    required this.likes,
  });
}

class PostWidget extends StatelessWidget {
  final Post post;
  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com avatar e username
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(post.userProfilePic),
                  backgroundColor: Colors.grey[900],
                ),
                const SizedBox(width: 10),
                Text(
                  post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Imagem da postagem
          Image.network(post.postImage, width: double.infinity, fit: BoxFit.cover),

          // Likes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              '${post.likes} curtidas',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Legenda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: post.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: post.caption),
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
