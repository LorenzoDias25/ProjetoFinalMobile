import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NovaReceitaScreen extends StatefulWidget {
  final String? editId;
  const NovaReceitaScreen({super.key, this.editId});

  @override
  _NovaReceitaScreenState createState() => _NovaReceitaScreenState();
}

class _NovaReceitaScreenState extends State<NovaReceitaScreen> {
  final _tituloController = TextEditingController();
  final _ingredientes = <TextEditingController>[];
  final _modos = <TextEditingController>[];
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _tituloController.addListener(_onCampoAlterado);
    _ingredientes.add(_novoController());
    _modos.add(_novoController());

    if (widget.editId != null) _carregarDados();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _ingredientes.forEach((c) => c.dispose());
    _modos.forEach((c) => c.dispose());
    super.dispose();
  }

  void _onCampoAlterado() {
    setState(() {}); // Força atualização do botão
  }

  TextEditingController _novoController({String? texto}) {
    final controller = TextEditingController(text: texto);
    controller.addListener(_onCampoAlterado);
    return controller;
  }

  void _carregarDados() async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('receitas')
        .doc(widget.editId)
        .get();

    _tituloController.text = doc['titulo'];
    _ingredientes.clear();
    for (var i in doc['ingredientes']) {
      _ingredientes.add(_novoController(texto: i));
    }
    _modos.clear();
    for (var i in doc['modoPreparo']) {
      _modos.add(_novoController(texto: i));
    }
    setState(() {});
  }

  void _salvar() async {
    final receita = {
      'titulo': _tituloController.text,
      'ingredientes': _ingredientes.map((e) => e.text).toList(),
      'modoPreparo': _modos.map((e) => e.text).toList(),
    };
    if (widget.editId != null) {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('receitas')
          .doc(widget.editId)
          .update(receita);
    } else {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('receitas')
          .add(receita);
    }
    Navigator.pop(context);
  }

  bool get _podeSalvar {
    final nome = _tituloController.text.trim().isNotEmpty;
    final temIngrediente = _ingredientes.any((c) => c.text.trim().isNotEmpty);
    final temPasso = _modos.any((c) => c.text.trim().isNotEmpty);
    return nome && temIngrediente && temPasso;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editId != null ? 'Editar Receita' : 'Nova Receita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 16),
            Text('Ingredientes'),
            ..._ingredientes.map((c) => TextField(controller: c)),
            TextButton(
              onPressed: () =>
                  setState(() => _ingredientes.add(_novoController())),
              child: Text('+ Ingrediente'),
            ),
            TextButton(
              onPressed: _ingredientes.length > 1
                  ? () {
                      setState(() {
                        _ingredientes.removeLast();
                      });
                    }
                  : null,
              child: Text('- Ingrediente'),
            ),
            SizedBox(height: 16),
            Text('Modo de Preparo'),
            ..._modos.map((c) => TextField(controller: c)),
            TextButton(
              onPressed: () => setState(() => _modos.add(_novoController())),
              child: Text('+ Passo'),
            ),
            TextButton(
              onPressed: _modos.length > 1
                  ? () {
                      setState(() {
                        _modos.removeLast();
                      });
                    }
                  : null,
              child: Text('- Passo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _podeSalvar ? _salvar : null,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
