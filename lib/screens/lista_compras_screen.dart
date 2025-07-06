import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListaComprasScreen extends StatefulWidget {
  const ListaComprasScreen({super.key});

  @override
  _ListaComprasScreenState createState() => _ListaComprasScreenState();
}

class _ListaComprasScreenState extends State<ListaComprasScreen> {
  final tituloController = TextEditingController();
  final itens = <TextEditingController>[];
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    tituloController.addListener(_onCamposAlterados);
    itens.add(_novoController());
  }

  @override
  void dispose() {
    tituloController.dispose();
    for (var c in itens) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _novoController() {
    final controller = TextEditingController();
    controller.addListener(_onCamposAlterados);
    return controller;
  }

  void _onCamposAlterados() {
    setState(() {});
  }

  bool get _podeSalvar {
    final nomePreenchido = tituloController.text.trim().isNotEmpty;
    final temItemValido = itens.any((c) => c.text.trim().isNotEmpty);
    return nomePreenchido && temItemValido;
  }

  void _salvarLista() async {
    final dados = {
      'titulo': tituloController.text,
      'itens': itens.map((e) => e.text).toList(),
    };
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('listas')
        .add(dados);
    Navigator.pop(context);
  }

  void _mostrarFormularioNovaLista() {
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
                    decoration: InputDecoration(labelText: 'Nome'),
                  ),
                  ...itens.map(
                    (c) => TextField(
                      controller: c,
                      decoration: InputDecoration(labelText: 'Item'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final novo = _novoController();
                      setState(() => itens.add(novo));
                      setModalState(() {}); // Atualiza o bottom sheet
                    },
                    child: Text('+ Item'),
                  ),
                  TextButton(
                    onPressed: itens.length > 1
                        ? () {
                            final removido = itens.removeLast();
                            removido.dispose();
                            setModalState(() {});
                            setState(() {});
                          }
                        : null,
                    child: Text('- Item'),
                  ),
                  ElevatedButton(
                    onPressed: _podeSalvar ? _salvarLista : null,
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

  void _mostrarOpcoesLista(BuildContext context, String id) {
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
                  title: Text('Excluir lista'),
                  content: Text(
                    'Deseja realmente excluir esta lista de compras?',
                  ),
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
                            .collection('listas')
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
        title: Text('Listas de Compras'),
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
            .collection('listas')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final listas = snapshot.data!.docs;
          return ListView.builder(
            itemCount: listas.length,
            itemBuilder: (context, index) {
              final doc = listas[index];
              return GestureDetector(
                onDoubleTap: () => _mostrarOpcoesLista(context, doc.id),
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(doc['titulo']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List<String>.from(
                        doc['itens'],
                      ).map((e) => Text('- $e')).toList(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioNovaLista,
        child: Icon(Icons.add),
      ),
    );
  }
}
