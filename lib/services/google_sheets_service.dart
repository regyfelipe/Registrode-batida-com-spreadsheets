import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis_auth/auth_io.dart';
import '../models/user.dart';

class GoogleSheetsService {
  static const _scopes = [sheets.SheetsApi.spreadsheetsScope];
  final auth.ServiceAccountCredentials _credentials;

  GoogleSheetsService(this._credentials);

  Future<List<User>> fetchUsers(String spreadsheetId) async {
    final client = await clientViaServiceAccount(_credentials, _scopes);
    final sheetsApi = sheets.SheetsApi(client);

    try {
      final response = await sheetsApi.spreadsheets.values
          .get(spreadsheetId, '3. Funcionarios!A:D');
      final List<List<dynamic>> rows = response.values ?? [];

      List<User> users = [];
      for (var row in rows.skip(1)) {
        users.add(User.fromJson(row));
      }

      return users;
    } finally {
      client.close();
    }
  }

  Future<void> appendOrUpdateRow({
  required String spreadsheetId,
  required String date,
  required String name,
  required String batida,
  required String tipoBatida, 
}) async {
  final client = await clientViaServiceAccount(_credentials, _scopes);
  final sheetsApi = sheets.SheetsApi(client);

  try {
    print("Iniciando o append ou update na planilha...");
    final response = await sheetsApi.spreadsheets.values.get(
      spreadsheetId,
      '1. Batidas!B:G',
    );

    final rows = response.values ?? [];
    print("Linhas existentes: ${rows.length}");

    int? matchingRowIndex;
    for (int i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isNotEmpty &&
          row.length >= 2 &&
          row[0] == date &&
          row[1] == name) {
        matchingRowIndex = i;
        print("Registro encontrado na linha: $i");
        break;
      }
    }

    if (matchingRowIndex != null) {
      final row = rows[matchingRowIndex];

      while (row.length < 6) {
        row.add('');
      }

      // Verifica o tipo de batida e preenche a coluna correta
      if (tipoBatida == "entrada") {
        row[2] = batida;  // Coluna D
        print("Batida de entrada registrada na coluna D (Entrada) na linha ${matchingRowIndex + 1}");
      } else if (tipoBatida == "saidaIntervalo") {
        row[3] = batida;  // Coluna E
        print("Batida de saída de intervalo registrada na coluna E (Saída Intervalo) na linha ${matchingRowIndex + 1}");
      } else if (tipoBatida == "retornoIntervalo") {
        row[4] = batida;  // Coluna F
        print("Batida de retorno de intervalo registrada na coluna F (Retorno Intervalo) na linha ${matchingRowIndex + 1}");
      } else if (tipoBatida == "saida") {
        row[5] = batida;  // Coluna G
        print("Batida de saída registrada na coluna G (Saída) na linha ${matchingRowIndex + 1}");
      }

      var valueRange = sheets.ValueRange(values: [row]);
      await sheetsApi.spreadsheets.values.update(
        valueRange,
        spreadsheetId,
        '1. Batidas!B${matchingRowIndex + 1}:G${matchingRowIndex + 1}',
        valueInputOption: 'RAW',
      );

      print("Registro atualizado com sucesso!");
    } else {
      List<String> newRow = [date, name, '', '', '', ''];
      if (tipoBatida == "entrada") {
        newRow[2] = batida;  // Adiciona na coluna D
      } else if (tipoBatida == "saidaIntervalo") {
        newRow[3] = batida;  // Adiciona na coluna E
      } else if (tipoBatida == "retornoIntervalo") {
        newRow[4] = batida;  // Adiciona na coluna F
      } else if (tipoBatida == "saida") {
        newRow[5] = batida;  // Adiciona na coluna G
      }

      var valueRange = sheets.ValueRange(values: [newRow]);
      await sheetsApi.spreadsheets.values.append(
        valueRange,
        spreadsheetId,
        '1. Batidas!B:G',
        valueInputOption: 'RAW',
      );
      print("Novo registro adicionado com sucesso.");
    }
  } catch (e) {
    print("Erro ao salvar registro: $e");
  } finally {
    client.close();
  }
}


  static Future<auth.ServiceAccountCredentials> loadCredentials() async {
    final String jsonString = await rootBundle
        .loadString('assets/controle-de-ponto-436814-0490dfdc67b9.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return auth.ServiceAccountCredentials.fromJson(jsonMap);
  }
}
