import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VisualizarReceitaScreen extends StatelessWidget {
  final String docId;
  const VisualizarReceitaScreen({required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Receita')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('receitas').doc(docId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(data['titulo'], style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 16),
                Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...List<String>.from(data['ingredientes']).map((i) => Text('- $i')),
                SizedBox(height: 16),
                Text('Modo de Preparo:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...List<String>.from(data['modoPreparo']).map((m) => Text('• $m')),
              ],
            ),
          );
        },
      ),
    );
  }
}
