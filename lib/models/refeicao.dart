class Refeicao {
  String id;
  String titulo;
  String horario;
  List<Map<String, String>> ingredientes;
  int calorias;
  String descricao;

  Refeicao({required this.id, required this.titulo, required this.horario, required this.ingredientes, required this.calorias, required this.descricao});
}
