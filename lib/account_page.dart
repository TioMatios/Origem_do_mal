import 'package:flutter/material.dart';
// 1. Precisamos importar o pacote de SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Valores padrão que serão substituídos pelos dados salvos
  String username = "Carregando...";
  String fullName = "Carregando...";
  String email = "Carregando...";

  @override
  void initState() {
    super.initState();
    // 2. Chamamos a função para carregar os dados ao iniciar a tela
    _carregarDadosPerfil();
  }

  // 3. Nova função para CARREGAR os dados
  Future<void> _carregarDadosPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // CORREÇÃO: Adicionado 'this.' para resolver o bug do analisador
      this.username = prefs.getString('perfil_username') ?? "Josiéli@mika";
      this.fullName = prefs.getString('perfil_fullName') ?? "Descrição";
      this.email = prefs.getString('perfil_email') ?? "josieli.mika@exemplo.com";
    });
  }

  // 4. Função "Editar Perfil" (Descrição) atualizada para SALVAR
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
                hintText: 'Descrição',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // 4a. A função onPressed agora é async
              onPressed: () async {
                final novaDescricao = nomeController.text;

                // 4b. Salva o dado no SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('perfil_fullName', novaDescricao);

                // 4c. Atualiza o estado local
                setState(() {
                  fullName = novaDescricao;
                });
                if (mounted) Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Função "Configurações" (Nome e Email) atualizada para SALVAR
  void _abrirConfiguracoes() {
    final usernameController = TextEditingController(text: username);
    final emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Configurações', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nome de usuário',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // 5a. A função onPressed agora é async
              onPressed: () async {
                final novoUsername = usernameController.text;
                final novoEmail = emailController.text;

                // 5b. Salva os dados no SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('perfil_username', novoUsername);
                await prefs.setString('perfil_email', novoEmail);

                // 5c. Atualiza o estado local
                setState(() {
                  username = novoUsername;
                  email = novoEmail;
                });
                if (mounted) Navigator.pop(context);
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
            onPressed: _abrirConfiguracoes,
          ),
        ],
      ),
      body: ListView(
        children: [
          ProfileHeader(
            username: username,
            fullName: fullName,
            email: email,
          ),
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

// ... (NENHUMA MUDANÇA necessária nos widgets abaixo)

class ProfileHeader extends StatelessWidget {
  final String username;
  final String fullName;
  final String email;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.fullName,
    required this.email,
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
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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
    // CORREÇÃO: Mudei de 12 para 18 e de .jpg para .jpeg
    final fotos = List.generate(18, (i) => 'images/imagem${i + 1}.jpeg');

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
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                fotos[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.grey);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}