class Usuario {
  String nome;
  int idade;
  String cpf;
  String email;
  String telefone;
  String endereco;
  String sexo;

  Usuario({required this.nome, required this.idade, required this.cpf, required this.email, required this.telefone, required this.endereco, required this.sexo});

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'idade': idade,
    'cpf': cpf,
    'email': email,
    'telefone': telefone,
    'endereco': endereco,
    'sexo': sexo,
  };
}
