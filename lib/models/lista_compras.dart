class ListaCompras {
  String id;
  String titulo;
  List<Map<String, String>> itens; // Ex: [{'nome': 'Tomate', 'quantidade': '2'}]

  ListaCompras({required this.id, required this.titulo, required this.itens});
}
