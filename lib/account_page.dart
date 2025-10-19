import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String username = "Josiéli@mika";
  String fullName = "Descrição";

  void editarPerfil() {
    final nomeController = TextEditingController(text: fullName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Editar descrição', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Nome',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  fullName = nomeController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          ProfileHeader(username: username, fullName: fullName),
          const Divider(color: Colors.white30),
          const ProfileStats(),
          const Divider(color: Colors.white30),
          EditProfileButton(onPressed: editarPerfil),
          const Divider(color: Colors.white30),
          const PhotoGrid(),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String username;
  final String fullName;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.fullName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              'https://avatars.githubusercontent.com/u/14101776?v=4',
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          ProfileStatItem(label: 'Posts', value: '120'),
          ProfileStatItem(label: 'Followers', value: '1.2k'),
          ProfileStatItem(label: 'Following', value: '180'),
        ],
      ),
    );
  }
}

class ProfileStatItem extends StatelessWidget {
  final String label;
  final String value;

  const ProfileStatItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class EditProfileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditProfileButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          minimumSize: const Size.fromHeight(50),
        ),
        child: const Text('Editar perfil'),
      ),
    );
  }
}

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final fotos = List.generate(12, (i) => 'images/imagem${i + 1}.jpg');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: fotos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(fotos[index]),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
  }
}
