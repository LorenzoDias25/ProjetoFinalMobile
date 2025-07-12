# 📱 Recipe Flutter - Aplicativo de Receitas, Planejamento de Refeições e Lista de Compras

---

## 1. 📝 Descrição do Projeto

### 🎯 Tema Escolhido:
Aplicativo de apoio à alimentação pessoal — gestão de receitas, planejamento de refeições e listas de compras.

### 📌 Objetivo:
Desenvolver um app completo em Flutter com integração Firebase, que ajude usuários a organizar suas refeições, registrar suas receitas favoritas e facilitar o controle de compras no dia a dia.

### ✅ Funcionalidades Implementadas:

- Login e Cadastro de usuários com autenticação por e-mail e senha
- Tela de perfil com dados pessoais
- Criação, edição e exclusão de **receitas culinárias**
- Planejamento de refeições semanais com calorias e horários
- Listas de compras com itens e quantidades
- Marcação de receitas como favoritas
- Armazenamento de dados segregado por usuário (Firestore)
- Notificações locais para lembretes de preparo

---

## 2. 🗂 Estrutura do Projeto

### 📁 Organização em Pastas


### 🔧 Frameworks e Bibliotecas Utilizadas

- **Flutter**: Framework principal
- **Firebase Auth**: Autenticação de usuários
- **Cloud Firestore**: Banco de dados em nuvem
- **flutter_local_notifications**: Agendamento de notificações locais
- **Provider**: Gerenciamento de estado
- **Material Design**: Interface nativa para Android

### 🔄 Fluxo de Telas e Navegação

1. **LoginScreen** → Tela inicial (login com email e senha)
2. **RegistroScreen** → Tela de criação de conta
3. **HomeScreen** → Lista de receitas
   - Botões para navegar para: Perfil, Lista de Compras e Planejamento
4. A partir do Home, o usuário pode:
   - Criar nova receita
   - Ver detalhes ou editar uma receita
   - Criar ou editar listas e planejamentos
5. **Perfil do Usuário** com botão de logout

---

## 3. 🔁 Aplicação de Padrões de Projeto

### 🧱 Padrões Criacionais

**🔹 Singleton**  
- **Problema resolvido**: Garantir que os serviços (como autenticação e notificações) tenham uma única instância durante o ciclo de vida do app.
- **Aplicação**: `NotificationService` e `AuthService` são implementados como singletons, centralizando o controle e evitando múltiplas instâncias.

### 🧩 Padrões Estruturais

**🔹 Adapter**  
- **Problema resolvido**: Tornar compatível a interface do Firebase com a lógica do app.
- **Aplicação**: A classe `AuthService` atua como um adaptador para `FirebaseAuth`, escondendo detalhes de implementação e permitindo mudanças futuras com baixo acoplamento.

### 🔁 Padrões Comportamentais

**🔹 Observer**  
- **Problema resolvido**: Manter a interface reativa à mudanças de estado do usuário.
- **Aplicação**: O `Provider` implementa Observer para escutar mudanças no login e recarregar automaticamente as informações da interface (por exemplo, ao salvar perfil ou alternar usuário).

---

## 4. ✅ Conclusão

### 📚 O que foi aprendido:

- Integração entre Flutter e Firebase (Firestore + Auth)
- Organização de estados e dados por usuário
- Implementação de múltiplas funcionalidades em um só app (CRUD, autenticação, notificações)
- Boas práticas com separação de responsabilidades

### 😓 Dificuldades encontradas:

- Lidar com o escopo dos dados do Firestore para múltiplos usuários
- Sincronizar informações do perfil com os dados da conta Firebase
- Controle de rotas e navegação entre telas complexas

### 💡 Sugestões de melhorias futuras:

- Compartilhamento de receitas entre usuários
- Upload de imagens para receitas
- Adicionar login com Google ou redes sociais
- Dashboard com gráfico nutricional
- Organização de categorias ou filtros por saúde, calorias etc.

---

## ✍️ Autor

Desenvolvido por [Lorenzo Canabarro Dias](https://github.com/LorenzoDias25)

---

## 📃 Licença

Este projeto é licenciado para fins educacionais e pessoais.  
Sinta-se à vontade para adaptar, modificar e reutilizar.
