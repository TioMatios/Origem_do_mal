# 📸 Instagram Clone (School Project)

*[Read in English](#-english-version-below)*

---

## 🇧🇷 Versão em Português

Este é um projeto acadêmico desenvolvido utilizando a linguagem **Dart** e o framework **Flutter**. O objetivo foi replicar as principais funcionalidades e o design do Instagram, integrando consumo de API e armazenamento local.

### 🚀 Funcionalidades

O aplicativo simula a experiência do Instagram com as seguintes features:

* **Splash Screen:** Tela de carregamento com a logo do Instagram.
* **Feed Inicial (Home):** Exibição de posts (falsos) com legendas, fotos e contagem de likes.
* **Interatividade:** Botões de curtir funcionais e barra de navegação (bottom navigation) presente em todas as telas.
* **Busca (Search):** Tela de pesquisa para navegar pelo conteúdo do app.
* **Postagem (Create):** Tela para seleção de imagem com pré-visualização.
* **Reels:** Interface de rolagem vertical infinita com imagens estáticas e botão de curtir (simulação de reels).
* **Perfil (Profile):** Funcionalidade para visualizar e editar informações do usuário (Nome, Email e Bio).

### 🛠️ Tecnologias Utilizadas

* [Flutter](https://flutter.dev/) - Framework de UI.
* [Dart](https://dart.dev/) - Linguagem de programação.
* **API Externa:** Integração com [JSON Posts](https://jsonplaceholder.typicode.com/) (ou similar) para gerar dados fictícios.
* **Persistência de Dados:** Uso do plugin `shared_preferences` para armazenamento local de dados.

### 👥 Colaboração

Este projeto foi desenvolvido colaborativamente por **Matheus** e **Ismael**. A divisão de tarefas foi realizada da seguinte forma:

#### Matheus
* **Tela "Início" (Home):** Desenvolvimento da UI da página principal, implementação da Splash Screen e integração visual dos posts.
* **Tela "Create":** Desenvolvimento da interface de criação de posts, permitindo a seleção e visualização da imagem escolhida pelo usuário.
* **Tela "Search":** Desenvolvimento da interface da tela de pesquisa.

#### Ismael
* **Integração de API:** Lógica de consumo da API "Json Posts" para popular o aplicativo com likes, fotos e legendas fictícias.
* **Tela "Profile":** Desenvolvimento da tela de perfil, incluindo a lógica de edição de dados do usuário (Nome, Email, Bio).
* **Tela "Reels":** Implementação da aba de Reels com design fiel ao original e funcionalidade de scroll (nota: utiliza imagens estáticas devido a restrições técnicas).

---

## <a name="-english-version-below"></a>🇺🇸 English Version

This is a school project built with the **Dart** language and the **Flutter** framework. The goal was to replicate the core features and design of Instagram, integrating API consumption and local storage.

### 🚀 Features

The app simulates the Instagram experience with the following features:

* **Splash Screen:** Loading screen featuring the Instagram logo.
* **Home Feed:** Displays fake posts with captions, photos, and like counts using external data.
* **Interactivity:** Functional "Like" buttons and a consistent navigation bar across all screens.
* **Search Screen:** Search interface to navigate through app content.
* **Create Post:** A screen that allows image selection with an on-screen preview functionality.
* **Reels:** Vertical scrolling interface with static images and like buttons (simulating the reels experience).
* **Profile:** Functionality to view and edit user information (Name, Email, and Bio).

### 🛠️ Tech Stack

* [Flutter](https://flutter.dev/) - UI Framework.
* [Dart](https://dart.dev/) - Programming Language.
* **External API:** Integrated with "JSON Posts" to generate mock data (posts, likes, photos).
* **Data Persistence:** Uses the `shared_preferences` plugin for local data storage.

### 👥 Collaboration

This is a collaborative project developed by **Matheus** and **Ismael**. The workload was distributed as follows:

#### Matheus
* **"Inicio" (Home) Screen:** Developed the main UI, implemented the Splash Screen, and handled the visual presentation of API data.
* **"Create" Screen:** Built the post creation interface, enabling image selection and preview similar to the original app design.
* **"Search" Screen:** Developed the search interface UI.

#### Ismael
* **API Integration:** Implemented the logic to fetch data from the "Json Posts" API to populate the app with fake likes, photos, and captions.
* **"Profile" Screen:** Developed the profile page, including features to edit account details (Name, Email, Bio).
* **"Reels" Screen:** Created the Reels interface with scrolling functionality and design faithful to Instagram (Note: Uses static images due to technical scope).

---

## 🔧 How to Run / Como rodar o projeto

1. Clone this repository / Clone este repositório:
   ```bash
   git clone [https://github.com/your-username/your-repo.git](https://github.com/your-username/your-repo.git)
