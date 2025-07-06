import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetofinalmobile/screens/planejamento_refeicoes_screen.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'nova_receita_screen.dart';
import 'visualizar_receita_screen.dart';
import 'lista_compras_screen.dart';
import 'perfil_usuario_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mapa para armazenar IDs das receitas favoritas locais
  Set<String> favoritasIds = {};

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Busca as receitas favoritas do usuário para inicializar o estado
  Future<void> _carregarFavoritas() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('favoritas')
        .get();

    setState(() {
      favoritasIds = snapshot.docs.map((d) => d.id).toSet();
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarFavoritas();
  }

  void _toggleFavorita(DocumentSnapshot receita) async {
    final docRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('favoritas')
        .doc(receita.id);

    final isFavorita = favoritasIds.contains(receita.id);

    if (isFavorita) {
      await docRef.delete();
      setState(() {
        favoritasIds.remove(receita.id);
      });
    } else {
      await docRef.set(receita.data()! as Map<String, dynamic>);
      setState(() {
        favoritasIds.add(receita.id);
      });
    }
  }

  void _mostrarOpcoes(BuildContext context, String docId) {
    // Seu código original do modal, sem alterações
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Alterar'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NovaReceitaScreen(editId: docId),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.visibility),
            title: Text('Exibir'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VisualizarReceitaScreen(docId: docId),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Excluir'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Confirmar exclusão'),
                  content: Text('Deseja realmente excluir esta receita?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('receitas')
                            .doc(docId)
                            .delete();
                        if (!mounted) return;
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
    final _ = Provider.of<AuthService>(context);
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Receitas'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PerfilUsuarioScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ListaComprasScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.food_bank),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PlanejamentoRefeicoesScreen()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('receitas')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final receitas = snapshot.data!.docs;
          return ListView.builder(
            itemCount: receitas.length,
            itemBuilder: (context, index) {
              final doc = receitas[index];
              final isFavorita = favoritasIds.contains(doc.id);

              return GestureDetector(
                onDoubleTap: () => _mostrarOpcoes(context, doc.id),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(doc['titulo']),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorita ? Icons.favorite : Icons.favorite_border,
                        color: isFavorita ? Colors.red : null,
                      ),
                      onPressed: () => _toggleFavorita(doc),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NovaReceitaScreen()),
        ),
      ),
    );
  }
}
