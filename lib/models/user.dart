class User {
  final String nome;
  final String username;
  final String cpf;
  final String senha;

  User({required this.nome, required this.username, required this.cpf, required this.senha});

  factory User.fromJson(List<dynamic> json) {
    return User(
      nome: json[0],     // Coluna A
      username: json[1], // Coluna B
      cpf: json[2],      // Coluna C
      senha: json[3],    // Coluna D
    );
  }
}
