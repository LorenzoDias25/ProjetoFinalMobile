class Receita {
  String id;
  String titulo;
  List<Map<String, String>> ingredientes; // Ex: [{'nome': 'Arroz', 'quantidade': '1 xícara'}]
  List<String> modoPreparo;

  Receita({required this.id, required this.titulo, required this.ingredientes, required this.modoPreparo});
}
