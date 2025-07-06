# 🍽️ Recipe Flutter

Um aplicativo mobile completo feito em Flutter com Firebase, que permite aos usuários:

- Criar e gerenciar **receitas** pessoais
- Planejar suas **refeições semanais**
- Criar e editar **listas de compras**
- Armazenar informações do **perfil do usuário**
- Favoritar receitas
- Autenticar com **e-mail e senha**
- Receber lembretes via **notificações locais**

---

## ✅ Funcionalidades

- 📋 **Cadastro/Login com Firebase Auth**
- 👤 **Perfil do usuário** com campos como nome, idade, CPF, telefone, endereço e sexo
- 🍽️ **Criação e visualização de receitas**
- 🧠 **Planejamento de refeições** com calorias, horários e descrição
- 🛒 **Lista de compras** personalizada com itens e quantidades
- ❤️ **Favoritar receitas**
- 🔔 **Notificações locais** de lembrete de preparo
- 🧾 **Armazenamento individual por usuário (Firestore)**

---

## 📦 Tecnologias Utilizadas

- [Flutter](https://flutter.dev/)
- [Firebase Auth](https://firebase.google.com/products/auth)
- [Cloud Firestore](https://firebase.google.com/products/firestore)
- [Provider](https://pub.dev/packages/provider)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)

---

## 🔧 Requisitos para Executar

Antes de rodar o projeto, você precisa:

### 📁 1. Ter instalado:
- Flutter SDK (versão recomendada: 3.19 ou superior)
- Android Studio ou VS Code com plugin Flutter
- Conta no Firebase e um projeto configurado

### 🔑 2. Configurar Firebase:
- Ative **Authentication > Email/Password**
- Ative **Cloud Firestore**
- Crie o app Android no Firebase Console
- Baixe o `google-services.json` e coloque em `android/app/`

### ⚙️ 3. Adicione ao seu `pubspec.yaml`:

dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.31.0
  firebase_auth: ^4.18.0
  cloud_firestore: ^4.16.0
  provider: ^6.1.2
  flutter_local_notifications: ^16.3.2

---

## ✍️ Autor

Desenvolvido por [Lorenzo Canabarro Dias](https://github.com/LorenzoDias25)  
Projeto criado com fins educacionais, acadêmicos e de prática com Flutter + Firebase.

---

## 📃 Licença

Este projeto é licenciado para fins **educacionais e pessoais**.  
Você pode utilizar, modificar e adaptar livremente este código, desde que mantenha os devidos créditos ao autor.

Distribuição comercial não é autorizada sem permissão prévia.
