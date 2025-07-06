import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();
  final enderecoController = TextEditingController();
  String sexo = 'Masculino';

  void _registrar() async {
    if (_formKey.currentState!.validate()) {
      try {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: senhaController.text.trim(),
        );

        await FirebaseFirestore.instance.collection('usuarios').doc(cred.user!.uid).set({
          'nome': nomeController.text,
          'idade': idadeController.text,
          'cpf': cpfController.text,
          'email': emailController.text,
          'telefone': telefoneController.text,
          'endereco': enderecoController.text,
          'sexo': sexo,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Conta')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: nomeController, decoration: InputDecoration(labelText: 'Nome')),
              TextFormField(controller: idadeController, decoration: InputDecoration(labelText: 'Idade')),
              TextFormField(controller: cpfController, decoration: InputDecoration(labelText: 'CPF')),
              TextFormField(controller: telefoneController, decoration: InputDecoration(labelText: 'Telefone')),
              TextFormField(controller: enderecoController, decoration: InputDecoration(labelText: 'Endereço')),
              DropdownButtonFormField(
                value: sexo,
                decoration: InputDecoration(labelText: 'Sexo'),
                items: ['Masculino', 'Feminino']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => sexo = val.toString()),
              ),
              TextFormField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
              TextFormField(
                controller: senhaController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _registrar,
                child: Text('Registrar'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                ),
                child: Text('Já tem uma conta? Entrar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
