
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/bate_ponto_screen.dart';
import '../services/google_sheets_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  Future<void> _login(BuildContext context) async {
    final credentials = await GoogleSheetsService.loadCredentials();
    final service = GoogleSheetsService(credentials);
    const spreadsheetId = '1rf2gf__Oauv2c4E0hia8GbvtLptj7l8K34SYWCWVg3o';

    try {
      final users = await service.fetchUsers(spreadsheetId);
      final username = usernameController.text;
      final password = passwordController.text;

      final user = users.firstWhere(
        (user) => user.username == username || user.cpf == username,
        orElse: () => User(nome: '', username: '', cpf: '', senha: ''),
      );

      if (user.nome.isNotEmpty && user.senha == password) {
        print('Login bem-sucedido: ${user.nome}');

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) =>
                BatePontoScreen(userName: user.nome), 
          ),
        );
      } else {
        print('Credenciais inválidas');
      }
    } catch (e) {
      print('Erro ao buscar usuários: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username ou CPF',
                  labelStyle:  const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide:  const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  const BorderSide(color: Colors.greenAccent),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  usernameController.text = value.toLowerCase();
                  usernameController.selection = TextSelection.fromPosition(
                    TextPosition(offset: usernameController.text.length),
                  );
                },
              ),
               const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                style:  const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle:  const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide:  const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  const BorderSide(color: Colors.greenAccent),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
               const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle:  const TextStyle(fontSize: 18),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
