import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlanejamentoRefeicoesScreen extends StatefulWidget {
  const PlanejamentoRefeicoesScreen({super.key});

  @override
  _PlanejamentoRefeicoesScreenState createState() =>
      _PlanejamentoRefeicoesScreenState();
}

class _PlanejamentoRefeicoesScreenState
    extends State<PlanejamentoRefeicoesScreen> {
  final tituloController = TextEditingController();
  final horarioController = TextEditingController();
  final caloriasController = TextEditingController();
  final descricaoController = TextEditingController();
  final ingredientes = <TextEditingController>[];
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    tituloController.addListener(_onCampoAlterado);
    horarioController.addListener(_onCampoAlterado);
    caloriasController.addListener(_onCampoAlterado);
    descricaoController.addListener(_onCampoAlterado);
    ingredientes.add(_novoController());
  }

  @override
  void dispose() {
    tituloController.dispose();
    horarioController.dispose();
    caloriasController.dispose();
    descricaoController.dispose();
    for (var c in ingredientes) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _novoController() {
    final controller = TextEditingController();
    controller.addListener(_onCampoAlterado);
    return controller;
  }

  void _onCampoAlterado() {
    setState(() {});
  }

  bool get _podeSalvar {
    final tituloOk = tituloController.text.trim().isNotEmpty;
    final horarioOk = horarioController.text.trim().isNotEmpty;
    final calorias = int.tryParse(caloriasController.text.trim()) ?? 0;
    final caloriasOk = calorias > 0;
    final descricaoOk = descricaoController.text.trim().isNotEmpty;
    final temIngrediente = ingredientes.any((c) => c.text.trim().isNotEmpty);
    return tituloOk && horarioOk && caloriasOk && descricaoOk && temIngrediente;
  }

  void _salvarPlanejamento() async {
    final dados = {
      'titulo': tituloController.text,
      'horario': horarioController.text,
      'ingredientes': ingredientes.map((e) => e.text).toList(),
      'calorias': caloriasController.text,
      'descricao': descricaoController.text,
    };
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('planejamentos')
        .add(dados);
    Navigator.pop(context);
  }

  void _mostrarFormularioNovoPlanejamento() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: StatefulBuilder(
          builder: (ctx, setModalState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: tituloController,
                    decoration: InputDecoration(
                      labelText: 'Título da refeição',
                    ),
                  ),
                  TextField(
                    controller: horarioController,
                    decoration: InputDecoration(labelText: 'Horário'),
                  ),
                  TextField(
                    controller: caloriasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantidade de calorias',
                    ),
                  ),
                  TextField(
                    controller: descricaoController,
                    decoration: InputDecoration(labelText: 'Descrição'),
                  ),
                  ...ingredientes.map(
                    (c) => TextField(
                      controller: c,
                      decoration: InputDecoration(labelText: 'Ingrediente'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final novo = _novoController();
                      setState(() => ingredientes.add(novo));
                      setModalState(() {});
                    },
                    child: Text('+ Ingrediente'),
                  ),
                  TextButton(
                    onPressed: ingredientes.length > 1
                        ? () {
                            final removido = ingredientes.removeLast();
                            removido.dispose();
                            setModalState(() {});
                            setState(() {});
                          }
                        : null,
                    child: Text('- Ingrediente'),
                  ),
                  ElevatedButton(
                    onPressed: _podeSalvar ? _salvarPlanejamento : null,
                    child: Text('Salvar'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _mostrarOpcoesPlanejamento(BuildContext context, String id) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Excluir'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Excluir planejamento'),
                  content: Text('Deseja realmente excluir este planejamento?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('usuarios')
                            .doc(uid)
                            .collection('planejamentos')
                            .doc(id)
                            .delete();
                        Navigator.pop(context);
                      },
                      child: Text('Excluir'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Planejamento de Refeições'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('planejamentos')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final planos = snapshot.data!.docs;
          return ListView.builder(
            itemCount: planos.length,
            itemBuilder: (context, index) {
              final doc = planos[index];
              return GestureDetector(
                onDoubleTap: () => _mostrarOpcoesPlanejamento(context, doc.id),
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(doc['titulo']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Horário: ${doc['horario']}'),
                        Text('Calorias: ${doc['calorias']}'),
                        Text('Descrição: ${doc['descricao']}'),
                        Text('Ingredientes:'),
                        ...List<String>.from(
                          doc['ingredientes'],
                        ).map((e) => Text('- $e')),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioNovoPlanejamento,
        child: Icon(Icons.add),
      ),
    );
  }
}
