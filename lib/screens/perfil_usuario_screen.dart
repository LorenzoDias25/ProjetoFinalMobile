import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  _PerfilUsuarioScreenState createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final enderecoController = TextEditingController();
  String sexo = 'Masculino';

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  void _carregarDadosUsuario() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();

    if (doc.exists) {
      final dados = doc.data()!;
      setState(() {
        nomeController.text = dados['nome'] ?? '';
        idadeController.text = dados['idade'] ?? '';
        cpfController.text = dados['cpf'] ?? '';
        emailController.text = dados['email'] ?? '';
        telefoneController.text = dados['telefone'] ?? '';
        enderecoController.text = dados['endereco'] ?? '';
        sexo = dados['sexo'] ?? 'Masculino';
      });
    }
  }

  void _salvarDados() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
      'nome': nomeController.text.trim(),
      'idade': idadeController.text.trim(),
      'cpf': cpfController.text.trim(),
      'email': emailController.text.trim(),
      'telefone': telefoneController.text.trim(),
      'endereco': enderecoController.text.trim(),
      'sexo': sexo,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dados salvos com sucesso.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Usuário'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                controller: idadeController,
                decoration: InputDecoration(labelText: 'Idade'),
              ),
              TextFormField(
                controller: cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
              ),
              TextFormField(
                controller: enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
              ),
              DropdownButtonFormField(
                value: sexo,
                items: ['Masculino', 'Feminino']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => sexo = val.toString()),
                decoration: InputDecoration(labelText: 'Sexo'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _salvarDados,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
